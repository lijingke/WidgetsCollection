//
//  LocalNotifications.swift
//
//  Created by Oleg Dreyman on 1/24/21.
//

#if canImport(UserNotifications)
import UserNotifications

public extension LocalNotifications {
    enum Log {
        public static var info: (Any) -> Void = { _ in }
    }
}

public extension LocalNotifications {
    struct PermissionStrategy {
        public init(groupLevel: LocalNotifications.PermissionStrategy.GroupLevel, systemLevel: LocalNotifications.PermissionStrategy.SystemLevel) {
            self.groupLevel = groupLevel
            self.systemLevel = systemLevel
        }
        
        public var groupLevel: GroupLevel
        public var systemLevel: SystemLevel
        
        public enum SystemLevel {
            case askPermission
            case ifAlreadyAllowed
        }
        
        public enum GroupLevel {
            case allowAutomatically
            case askPermission(AskPermissionMode, ApplicationLevelPermissionAsker)
            case ifAlreadyAllowed
            case ifAllowed(other: LocalNotificationsGroup)
            case bypass
            
            public enum AskPermissionMode {
                case once
                case alwaysIfNotAllowed
            }
        }
        
        public static let askSystemPermissionIfNeeded = PermissionStrategy(
            groupLevel: .bypass,
            systemLevel: .askPermission
        )
        
        public static let scheduleIfSystemAllowed = PermissionStrategy(
            groupLevel: .bypass,
            systemLevel: .ifAlreadyAllowed
        )
        
        public static func askWithPrePermission(
            _ mode: GroupLevel.AskPermissionMode,
            prePermission: ApplicationLevelPermissionAsker
        ) -> PermissionStrategy {
            return PermissionStrategy(
                groupLevel: .askPermission(mode, prePermission),
                systemLevel: .askPermission
            )
        }
    }
}

public extension LocalNotifications {
    struct ApplicationLevelPermissionAsker {
        let _ask: (_ completion: @escaping (Result<Bool, Swift.Error>) -> Void) -> Void
        
        public init(askPermission: @escaping (_ completion: @escaping (Result<Bool, Swift.Error>) -> Void) -> Void) {
            self._ask = askPermission
        }
        
        public func askPermission(completion: @escaping (Result<Bool, Swift.Error>) -> Void) {
            _ask(completion)
        }
    }
}

public enum LocalNotifications {
    public enum Env {
        public static var addNotificationRequest = UNUserNotificationCenter.current().add
        public static var removeDeliveredNotifications = UNUserNotificationCenter.current().removeDeliveredNotifications
        public static var removePendingNotificationRequests = UNUserNotificationCenter.current().removePendingNotificationRequests
        public static var getPendingNotificationRequests = UNUserNotificationCenter.current().getPendingNotificationRequests
        public static var getDeliveredNotifications = UNUserNotificationCenter.current().getDeliveredNotifications
    }
    
    public enum FinalAuthorizationStatus {
        case enabled
        case disabled
        case systemDenied
        
        public var isEnabled: Bool {
            return self == .enabled
        }
    }
    
    public static func currentAuthorizationStatus(forGroup group: LocalNotificationsGroup, completion: @escaping (FinalAuthorizationStatus) -> Void) {
        let completion = { status in
            DispatchQueue.main.async {
                completion(status)
            }
        }
        SystemAuthorization.getCurrent { status in
            switch status {
            case .deniedNow, .deniedPreviously:
                completion(.systemDenied)
            case .allowed:
                let appAuth = GroupLevelAuthorization.getCurrent(forGroup: group.groupIdentifier)
                switch appAuth {
                case .allowed:
                    completion(.enabled)
                case .denied, .notAsked:
                    completion(.disabled)
                }
            case .undetermined:
                completion(.disabled)
            }
        }
    }
    
    public static func requestPermission(strategy: PermissionStrategy, completion: @escaping (Bool) -> Void = { _ in }) {
        withPermission(strategy: strategy, perform: {}, completion: { completion($0.isAllowed) })
    }
    
    /// Identical to `disable(group:)`
    public static func remove(group: LocalNotificationsGroup) {
        disable(group: group)
    }
    
    public static func disable(group: LocalNotificationsGroup) {
        GroupLevelAuthorization.setIsAllowed(false, forGroup: group.groupIdentifier)
        removeAllPending(withGroup: group.groupIdentifier, completion: {})
    }
    
    @discardableResult
    public static func schedule(timeline: NotificationsTimeline, group: String? = nil, permissionStrategy: PermissionStrategy, completion: @escaping (SchedulingResult) -> Void = { _ in }) -> LocalNotificationsGroup {
        let adHoc = AdHocTimelineGroup(timeline: timeline, groupIdentifier: group)
        _reschedule(group: adHoc, permissionStrategy: permissionStrategy, clearExisting: false, completion: completion)
        return adHoc
    }
    
    @discardableResult
    static func schedule(content: UNMutableNotificationContent, at trigger: DateBuilder.ResolvedDate, group: String? = nil, permissionStrategy: PermissionStrategy, completion: @escaping (SchedulingResult) -> Void = { _ in }) -> LocalNotificationsGroup {
        let timeline = NotificationsTimeline {
            trigger.schedule(with: { content })
        }
        return schedule(timeline: timeline, group: group, permissionStrategy: permissionStrategy, completion: completion)
    }
    
    @discardableResult
    public static func schedule(permissionStrategy: PermissionStrategy, group: String? = nil, @TimelineBuilder _ timelineBuilder: () -> [LocalNotifications.NotificationRequest], completion: @escaping (SchedulingResult) -> Void = { _ in }) -> LocalNotificationsGroup {
        let timeline = NotificationsTimeline(timelineBuilder)
        return schedule(timeline: timeline, group: group, permissionStrategy: permissionStrategy, completion: completion)
    }
    
    public static func directSchedule(request: UNNotificationRequest, permissionStrategy: PermissionStrategy, completion: @escaping (SchedulingResult) -> Void = { _ in }) {
        withPermission(strategy: permissionStrategy) {
            Env.addNotificationRequest(request) { error in
                if let error = error {
                    completion(.systemError(error))
                } else {
                    completion(.scheduledSuccesfully)
                }
            }
        } completion: { result in
            if result.isDenied {
                completion(result.asSchedulingResult)
            }
        }
    }
    
    private final class AdHocTimelineGroup: LocalNotificationsGroup {
        let timeline: NotificationsTimeline
        let groupIdentifier: String
        
        init(timeline: NotificationsTimeline, groupIdentifier: String?) {
            self.timeline = timeline
            self.groupIdentifier = groupIdentifier ?? UUID().uuidString
        }
        
        func getTimeline(completion: @escaping (NotificationsTimeline) -> Void) {
            completion(timeline)
        }
    }
    
    public static func reschedule(group: LocalNotificationsGroup, permissionStrategy: PermissionStrategy, completion: @escaping (Bool) -> Void = { _ in }) {
        _reschedule(group: group, permissionStrategy: permissionStrategy, clearExisting: true, completion: { completion($0.isSuccess) })
    }
    
    public static func withPermission(strategy: PermissionStrategy, group: String? = nil, perform: @escaping () -> Void, completion: @escaping (_ isAllowed: PermissionResult) -> Void = { _ in }) {
        executeStrategy(permissionStrategy: strategy, forGroup: group ?? UUID().uuidString) { result in
            if result == .allowed {
                perform()
            }
            completion(result)
        }
    }
    
    public enum SchedulingResult {
        case scheduledSuccesfully
        case systemError(Swift.Error)
        case deniedOnGroupLevel
        case deniedOnSystemLevel
        
        public var isSuccess: Bool {
            switch self {
            case .scheduledSuccesfully:
                return true
            default:
                return false
            }
        }
    }
    
    private static func _reschedule(group: LocalNotificationsGroup, permissionStrategy: PermissionStrategy, clearExisting: Bool, completion: @escaping (SchedulingResult) -> Void) {
        assert(!group.groupIdentifier.contains(":"), "colon is reserved by the LocalNotifications framework")
        
        let mainQueueCompletion = { val in
            DispatchQueue.main.async { completion(val) }
        }
        Log.info("EXECUTING AUTH STRATEGY")
        
        withPermission(strategy: permissionStrategy, group: group.groupIdentifier) {
            Log.info("AUTH ALLOWED: scheduling notifications")
            
            let performScheduleInCurrentContext = {
                group.getTimeline { schedule in
                    let requests = schedule.requests
                    for request in requests {
                        self.scheduleRequest(request, in: group)
                    }
                }
                mainQueueCompletion(.scheduledSuccesfully)
            }
            
            let performSchedule = group.preferredExecutionContext == .mainQueueOnly
                ? { DispatchQueue.main.async(execute: performScheduleInCurrentContext) }
                : performScheduleInCurrentContext
            
            if clearExisting {
                removeAllPending(withGroup: group.groupIdentifier, completion: performSchedule)
            } else {
                performSchedule()
            }
        } completion: { result in
            if result.isDenied {
                Log.info("AUTH FAILED: removing all notifications for group \(group.groupIdentifier)")
                removeAllPending(withGroup: group.groupIdentifier, completion: {})
                mainQueueCompletion(result.asSchedulingResult)
            } else {
                resolveDelivered(group: group)
            }
        }
    }
    
    private static func resolveDelivered(group: LocalNotificationsGroup) {
        Env.getDeliveredNotifications { notifications in
            let inCategory = notifications
                .filter { $0.request.identifier.starts(with: group.groupIdentifier + ":") }
            for notification in inCategory {
                group.__shouldRemoveDeliveredNotification(notification: notification) { shouldRemove in
                    if shouldRemove {
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
                    }
                }
            }
        }
    }
    
    public enum PermissionResult {
        case allowed
        case deniedOnSystemLevel
        case deniedOnGroupLevel
        
        public var isAllowed: Bool { return self == .allowed }
        public var isDenied: Bool { !isAllowed }
        
        public var asSchedulingResult: SchedulingResult {
            switch self {
            case .allowed:
                return .scheduledSuccesfully
            case .deniedOnGroupLevel:
                return .deniedOnGroupLevel
            case .deniedOnSystemLevel:
                return .deniedOnSystemLevel
            }
        }
    }
    
    private static func executeStrategy(permissionStrategy: PermissionStrategy, forGroup groupIdentifier: String, completion: @escaping (PermissionResult) -> Void) {
        Log.info("EXECUTING CATEGORY APP STRATEGY")
        executeGroupStrategy(groupStrategy: permissionStrategy.groupLevel, forGroup: groupIdentifier) { isGranted in
            if isGranted {
                Log.info("CATEGORY APP STRATEGY: granted - moving on to system strategy")
                Log.info("EXECUTING SYSTEM STRATEGY")
                executeSystemStrategy(systemStrategy: permissionStrategy.systemLevel, completion: { isSystemGranted in
                    Log.info("SYSTEM STRATEGY: isGranted - \(isSystemGranted); completing")
                    completion(isSystemGranted ? .allowed : .deniedOnSystemLevel)
                })
            } else {
                Log.info("CATEGORY APP STRATEGY: denied - completing")
                completion(.deniedOnGroupLevel)
            }
        }
    }
    
    private static func executeGroupStrategy(groupStrategy: PermissionStrategy.GroupLevel, forGroup groupIdentifier: String, completion: @escaping (Bool) -> Void) {
        switch groupStrategy {
        case .allowAutomatically:
            Log.info("CATEGORY APP STRATEGY: allowAutomatically, setting as allowed and completing")
            GroupLevelAuthorization.setIsAllowed(true, forGroup: groupIdentifier)
            completion(true)
        case .askPermission(let mode, let permissionAsker):
            Log.info("CATEGORY APP STRATEGY: askPermission, checking if need to ask with mode: \(mode)")
            let modeResult = executeApplicationAskPermissionMode(mode: mode, forGroup: groupIdentifier)
            switch modeResult {
            case .shouldAskPermission:
                Log.info("CATEGORY APP STRATEGY: mode \(mode) decided that should ask permission, asking")
                assert(Thread.isMainThread)
                permissionAsker.askPermission { result in
                    switch result {
                    case .failure(let error):
                        Log.info("CATEGORY APP STRATEGY: askPermission, failed to ask permission an app level: \(error)")
                        completion(false)
                    case .success(let isGranted):
                        Log.info("CATEGORY APP STRATEGY: askPermission, completed with isGranted: \(isGranted); setting and completing")
                        GroupLevelAuthorization.setIsAllowed(isGranted, forGroup: groupIdentifier)
                        completion(isGranted)
                    }
                }
            case .shouldComplete(let isAllowed):
                Log.info("CATEGORY APP STRATEGY: mode \(mode) decided that should complete with isAllowed - \(isAllowed), completing")
                completion(isAllowed)
            }
        case .ifAlreadyAllowed:
            let isAllowedAlready = GroupLevelAuthorization
                .getCurrent(forGroup: groupIdentifier).isAllowed
            Log.info("CATEGORY APP STRATEGY: ifAlreadyAllowed, isAllowed: \(isAllowedAlready); completing")
            completion(isAllowedAlready)
        case .ifAllowed(other: let otherGroup):
            let isAllowedAlready = GroupLevelAuthorization
                .getCurrent(forGroup: otherGroup.groupIdentifier).isAllowed
            Log.info("CATEGORY APP STRATEGY: ifAllowed for other group: \(otherGroup.groupIdentifier), isAllowed: \(isAllowedAlready); completing")
            completion(isAllowedAlready)
        case .bypass:
            completion(true)
        }
    }
    
    enum AskPermissionResult {
        case shouldAskPermission
        case shouldComplete(Bool)
    }
    
    private static func executeApplicationAskPermissionMode(mode: PermissionStrategy.GroupLevel.AskPermissionMode, forGroup groupIdentifier: String) -> AskPermissionResult {
        let status = GroupLevelAuthorization.getCurrent(forGroup: groupIdentifier)
        switch status {
        case .notAsked:
            return .shouldAskPermission
        case .allowed:
            return .shouldComplete(true)
        case .denied:
            switch mode {
            case .alwaysIfNotAllowed:
                return .shouldAskPermission
            case .once:
                return .shouldComplete(false)
            }
        }
    }
    
    private static func executeSystemStrategy(systemStrategy: PermissionStrategy.SystemLevel, completion: @escaping (Bool) -> Void) {
        switch systemStrategy {
        case .ifAlreadyAllowed:
            Log.info("SYSTEM STRATEGY: ifAlreadyAllowed, checking")
            SystemAuthorization.getCurrent { status in
                Log.info("SYSTEM STRATEGY: ifAlreadyAllowed, result: \(status). finishing")
                completion(status.isAllowed)
            }
        case .askPermission:
            Log.info("SYSTEM STRATEGY: askPermission, showing if neccessary")
            SystemAuthorization.authorizeWithSystem { status in
                Log.info("SYSTEM STRATEGY: askPermission, result: \(status). finishing")
                completion((try? status.get().isAllowed) ?? false)
            }
        }
    }
    
    private static func scheduleRequest(_ request: NotificationRequest, in group: LocalNotificationsGroup) {
        for trigger in request.triggers.triggers {
            request.contentMaker.makeContent(date: trigger) { content in
                if let content = content {
                    let request = UNNotificationRequest(
                        identifier: group.groupIdentifier + ":" + trigger.identifier.rawValue,
                        content: content,
                        trigger: trigger.rawTrigger
                    )
                    Env.addNotificationRequest(request) { error in
                        Log.info("SCHEDULED \(request.identifier), \(error as Any)")
                    }
                } else {
                    Env.removeDeliveredNotifications([trigger.identifier.rawValue])
                    Env.removePendingNotificationRequests([trigger.identifier.rawValue])
                }
            }
        }
    }
    
    private static func removeAllPending(withGroup groupIdentifier: String, completion: @escaping () -> Void) {
        Env.getPendingNotificationRequests { requests in
            let inCategory = requests
                .filter { $0.identifier.starts(with: groupIdentifier + ":") }
                .map(\.identifier)
            Env.removePendingNotificationRequests(inCategory)
            Log.info("removed all notifications for group \(groupIdentifier), in total \(inCategory.count) requests")
            completion()
        }
    }
}

public extension LocalNotifications {
    enum GroupLevelAuthorization {
        public enum Env {
            public static var valueForKey = UserDefaults.standard.value(forKey:)
            public static var setValue = UserDefaults.standard.setValue(_:forKey:)
            
            public static func setUserDefaults(_ userDefaults: UserDefaults) {
                valueForKey = userDefaults.value(forKey:)
                setValue = userDefaults.setValue(_:forKey:)
            }
        }
                
        public static func _userDefaultsKey(forGroup groupIdentifier: String) -> String {
            return "___np_local_notifications_app_permission_group:\(groupIdentifier)"
        }
        
        public enum Status {
            case notAsked
            case allowed
            case denied
            
            public var isAllowed: Bool {
                return self == .allowed
            }
        }
        
        public static func getCurrent(forGroup groupIdentifier: String) -> Status {
            let key = Self._userDefaultsKey(forGroup: groupIdentifier)
            if let existingIsAlreadyAllowed = Env.valueForKey(key) as? Bool {
                return existingIsAlreadyAllowed ? .allowed : .denied
            } else {
                return .notAsked
            }
        }
        
        public static func setIsAllowed(_ isAllowed: Bool, forGroup groupIdentifier: String) {
            Log.info("group \(groupIdentifier): auth updated to isAllowed - \(isAllowed)")
            Env.setValue(isAllowed, _userDefaultsKey(forGroup: groupIdentifier))
        }
    }
}

public extension LocalNotifications {
    enum SystemAuthorization {
        public enum Env {
            public static var getNotificationSettings = UNUserNotificationCenter.current().getNotificationSettings
            public static var requestAuthorization = UNUserNotificationCenter.current().requestAuthorization
        }
        
        public enum Status {
            case allowed
            case deniedPreviously
            case deniedNow
            case undetermined
            
            public var isAllowed: Bool {
                return self == .allowed
            }
        }
        
        public static func getCurrent(_ completion: @escaping (Status) -> Void) {
            Env.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    completion(.allowed)
                case .denied:
                    completion(.deniedPreviously)
                case .ephemeral, .notDetermined, .provisional:
                    completion(.undetermined)
                default:
                    completion(.undetermined)
                }
            }
        }
        
        public static func authorizeWithSystem(options: UNAuthorizationOptions = [.alert, .badge, .sound], _ completion: @escaping (Result<Status, Swift.Error>) -> Void) {
            Env.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized, .notDetermined:
                    Env.requestAuthorization(options) { isSuccess, error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(isSuccess ? .allowed : .deniedNow))
                        }
                    }
                case .denied:
                    completion(.success(.deniedPreviously))
                default:
                    completion(.success(.undetermined))
                }
            }
        }
    }
}

public enum LocalNotificationsGroupContextPreference {
    case mainQueueOnly
    case canRunOnAnyQueue
}

public protocol LocalNotificationsGroup {
    var groupIdentifier: String { get }
    var preferredExecutionContext: LocalNotificationsGroupContextPreference { get }
    
    func getTimeline(completion: @escaping (NotificationsTimeline) -> Void)
    func __shouldRemoveDeliveredNotification(notification: UNNotification, completion: @escaping (Bool) -> Void)
}

public extension LocalNotificationsGroup {
    var preferredExecutionContext: LocalNotificationsGroupContextPreference { .mainQueueOnly }
    func __shouldRemoveDeliveredNotification(notification: UNNotification, completion: @escaping (Bool) -> Void) {
        completion(false)
    }
}

public struct NotificationsTimeline {
    public var requests: [LocalNotifications.NotificationRequest]
    
    public init(requests: [LocalNotifications.NotificationRequest]) {
        self.requests = requests
    }
    
    public init(@TimelineBuilder _ builder: () -> [LocalNotifications.NotificationRequest]) {
        self.requests = builder()
    }
    
    public init(combining timelines: NotificationsTimeline...) {
        self.requests = timelines.flatMap(\.requests)
    }
    
    public init(combining timelines: [NotificationsTimeline]) {
        self.requests = timelines.flatMap(\.requests)
    }
    
    public static var empty: NotificationsTimeline {
        return NotificationsTimeline(requests: [])
    }
}

public extension LocalNotifications {
    struct NotificationRequest {
        var triggers: NotificationTriggerSet
        var contentMaker: NotificationContentMaker
        
        public func withCategory(_ categoryIdentifier: String) -> NotificationRequest {
            return NotificationRequest(
                triggers: triggers,
                contentMaker: contentMaker.transform { $0.categoryIdentifier = categoryIdentifier }
            )
        }
        
        @available(watchOS 6.0, *)
        @available(iOS 13.0, *)
        public func withTargetContentIdentifier(_ targetContentIdentifier: String) -> NotificationRequest {
            return NotificationRequest(
                triggers: triggers,
                contentMaker: contentMaker.transform { $0.targetContentIdentifier = targetContentIdentifier }
            )
        }
    }
}

struct NotificationContentMaker {
    private let _make: (_ date: LocalNotifications.Trigger, _ completion: @escaping (UNMutableNotificationContent?) -> Void) -> Void
    
    func makeContent(date: LocalNotifications.Trigger, _ completion: @escaping (UNMutableNotificationContent?) -> Void) {
        _make(date, completion)
    }
    
    static func async(_ maker: @escaping (_ date: LocalNotifications.Trigger, _ completion: @escaping (UNMutableNotificationContent?) -> Void) -> Void) -> NotificationContentMaker {
        return NotificationContentMaker(_make: maker)
    }
    
    static func sync(_ maker: @escaping (LocalNotifications.Trigger) -> UNMutableNotificationContent?) -> NotificationContentMaker {
        return NotificationContentMaker { date, completion in
            let content = maker(date)
            completion(content)
        }
    }
    
    fileprivate func transform(_ perform: @escaping (UNMutableNotificationContent) -> Void) -> NotificationContentMaker {
        return NotificationContentMaker { trigger, completion in
            self.makeContent(date: trigger) { result in
                if let result = result {
                    perform(result)
                    completion(result)
                } else {
                    completion(result)
                }
            }
        }
    }
}

public extension LocalNotifications {
    struct Trigger {
        public var rawTrigger: UNNotificationTrigger
        public var identifier: NotificationContentIdentifier
        
        public var nextTriggerDate: Date {
            if let calendarBased = rawTrigger as? UNCalendarNotificationTrigger {
                return calendarBased.nextTriggerDate() ?? .distantFuture
            } else if let timeIntervalBased = rawTrigger as? UNTimeIntervalNotificationTrigger {
                return timeIntervalBased.nextTriggerDate() ?? .distantFuture
            } else {
                assertionFailure("unsupported trigger, no next trigger date!")
                return .distantFuture
            }
        }
    }
    
    struct NotificationContentIdentifier {
        public var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static func makeRandom() -> NotificationContentIdentifier {
            return .init(rawValue: UUID().uuidString)
        }
    }
}

public protocol NotificationsScheduling {
    static var keyPathForTriggerSet: (Self) -> LocalNotifications.NotificationTriggerSet { get }
}

extension Array: NotificationsScheduling where Element == DateBuilder.ResolvedDate {
    private var triggerSet: LocalNotifications.NotificationTriggerSet {
        let all = flatMap(\.triggerSet.triggers)
        return LocalNotifications.NotificationTriggerSet(triggers: all)
    }
    
    public static var keyPathForTriggerSet: (Self) -> LocalNotifications.NotificationTriggerSet {
        return \.triggerSet
    }
}

extension NotificationsScheduling {
    func schedule(with maker: NotificationContentMaker) -> LocalNotifications.NotificationRequest {
        return LocalNotifications.NotificationRequest(triggers: Self.keyPathForTriggerSet(self), contentMaker: maker)
    }
}

public extension NotificationsScheduling {
    func schedule(title: String? = nil, subtitle: String? = nil, body: String? = nil, sound: UNNotificationSound? = .default) -> LocalNotifications.NotificationRequest {
        let content = NotificationContent(title: title, subtitle: subtitle, body: body, sound: sound)
        return schedule(with: content)
    }
    
    func schedule(with maker: @escaping () -> UNMutableNotificationContent?) -> LocalNotifications.NotificationRequest {
        return schedule(with: .sync { _ in maker() })
    }
    
    func schedule(with maker: @escaping (LocalNotifications.Trigger) -> UNMutableNotificationContent?) -> LocalNotifications.NotificationRequest {
        return schedule(with: .sync(maker))
    }
    
    func schedule(with maker: @escaping (_ nextTriggerDate: Date) -> UNMutableNotificationContent?) -> LocalNotifications.NotificationRequest {
        return schedule(with: { maker($0.nextTriggerDate) })
    }
    
    func schedule(with asyncMaker: @escaping (_ trigger: LocalNotifications.Trigger, _ completion: @escaping (UNMutableNotificationContent?) -> Void) -> Void) -> LocalNotifications.NotificationRequest {
        return schedule(with: .async(asyncMaker))
    }
    
    func schedule(with asyncMaker: @escaping (_ nextTriggerDate: Date, _ completion: @escaping (UNMutableNotificationContent?) -> Void) -> Void) -> LocalNotifications.NotificationRequest {
        return schedule { trigger, completion in
            asyncMaker(trigger.nextTriggerDate, completion)
        }
    }
    
    func schedule(with asyncMaker: @escaping (_ completion: @escaping (UNMutableNotificationContent?) -> Void) -> Void) -> LocalNotifications.NotificationRequest {
        return schedule(with: .async { _, completion in asyncMaker(completion) })
    }
    
    func schedule(with content: @escaping @autoclosure () -> UNMutableNotificationContent?) -> LocalNotifications.NotificationRequest {
        return schedule(with: .sync { _ in content() })
    }
}

public extension LocalNotifications {
    struct NotificationTriggerSet: NotificationsScheduling {
        public var triggers: [LocalNotifications.Trigger]
        
        public static var keyPathForTriggerSet: (Self) -> LocalNotifications.NotificationTriggerSet {
            return \.self
        }
        
        public static var empty: NotificationTriggerSet { .init(triggers: []) }
        
        public static func single(trigger: LocalNotifications.Trigger) -> NotificationTriggerSet {
            return NotificationTriggerSet(triggers: [trigger])
        }
    }
}

public final class NotificationContent: UNMutableNotificationContent {
    public init(title: String? = nil, subtitle: String? = nil, body: String? = nil, sound: UNNotificationSound? = .default) {
        super.init()
        self.title = title ?? ""
        self.subtitle = subtitle ?? ""
        self.body = body ?? ""
        self.sound = sound
    }
    
    public static func muted(title: String? = nil, subtitle: String? = nil, body: String? = nil) -> NotificationContent {
        return NotificationContent(title: title, subtitle: subtitle, body: body, sound: nil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension DateBuilder.ResolvedDate: NotificationsScheduling {
    fileprivate var triggerSet: LocalNotifications.NotificationTriggerSet {
        switch self {
        case .components(let components):
            if Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .strict) == nil {
                // date is in the past
                return .empty
            } else {
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                return .single(trigger: .init(rawTrigger: trigger, identifier: .makeRandom()))
            }
        case .exact(let date):
            let now = Date()
            guard date > now else {
                return .empty
            }
            let interval = date.timeIntervalSince(now)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            return .single(trigger: .init(rawTrigger: trigger, identifier: .makeRandom()))
        }
    }
    
    public static var keyPathForTriggerSet: (Self) -> LocalNotifications.NotificationTriggerSet {
        return \.triggerSet
    }
}

extension LocalNotifications {
    struct Repeating {
        var repeatInterval: TimeInterval
    }
}

func Repeating(everySeconds seconds: TimeInterval) -> LocalNotifications.Repeating {
    return LocalNotifications.Repeating(repeatInterval: seconds)
}

extension LocalNotifications.Repeating: NotificationsScheduling {
    fileprivate var triggerSet: LocalNotifications.NotificationTriggerSet {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: repeatInterval, repeats: true)
        return .single(trigger: .init(rawTrigger: trigger, identifier: .makeRandom()))
    }

    static var keyPathForTriggerSet: (Self) -> LocalNotifications.NotificationTriggerSet {
        return \.triggerSet
    }
}

extension UNNotificationTrigger: NotificationsScheduling {
    fileprivate var triggerSet: LocalNotifications.NotificationTriggerSet {
        return .single(trigger: .init(rawTrigger: self, identifier: .makeRandom()))
    }

    public static var keyPathForTriggerSet: (UNNotificationTrigger) -> LocalNotifications.NotificationTriggerSet {
        return \.triggerSet
    }
}

@_functionBuilder
public enum TimelineBuilder {
    public typealias Expression = LocalNotifications.NotificationRequest
    public typealias Component = [LocalNotifications.NotificationRequest]

    public static func buildExpression(_ expression: Expression) -> Component {
        [expression]
    }

    public static func buildExpression(_ expression: Expression?) -> Component {
        expression.map { [$0] } ?? []
    }

    public static func buildBlock(_ children: Component...) -> Component {
        children.flatMap { $0 }
    }

    public static func buildOptional(_ children: Component?) -> Component {
        children ?? []
    }

    public static func buildBlock(_ component: Component) -> Component {
        component
    }

    public static func buildEither(first child: Component) -> Component {
        child
    }

    public static func buildEither(second child: Component) -> Component {
        child
    }
}

// MARK: - More

#if canImport(UIKit)
import UIKit

#if os(watchOS)
#else
public extension LocalNotifications.ApplicationLevelPermissionAsker {
    static func alert(on vc: UIViewController, title: String?, message: String?, noActionTitle: String, yesActionTitle: String) -> LocalNotifications.ApplicationLevelPermissionAsker {
        return LocalNotifications.ApplicationLevelPermissionAsker { completion in
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let no = UIAlertAction(title: noActionTitle, style: .default, handler: { _ in
                alertVC.dismiss(animated: true, completion: { completion(.success(false)) })
            })
            alertVC.addAction(no)
            let yes = UIAlertAction(title: yesActionTitle, style: .default, handler: { _ in
                alertVC.dismiss(animated: true, completion: { completion(.success(true)) })
            })
            alertVC.addAction(yes)
            alertVC.preferredAction = yes
            vc.present(alertVC, animated: true)
        }
    }
    
    /// en-US only
    static func defaultAlert(on vc: UIViewController) -> LocalNotifications.ApplicationLevelPermissionAsker {
        return alert(on: vc, title: "We'd like to send you notifications", message: "Notifications may include alerts, sounds and icon badges. These can be configured in Settings.", noActionTitle: "Not Now", yesActionTitle: "OK")
    }
}
#endif

extension UNNotificationAttachment {
    @available(*, deprecated, message: "not available yet")
    private static func create(identifier: String, image: UIImage, options: [NSObject: AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier + ".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            let imageData = UIImage.pngData(image)
            try imageData()?.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            LocalNotifications.Log.info("error " + error.localizedDescription)
        }
        return nil
    }
}

#endif
#endif
