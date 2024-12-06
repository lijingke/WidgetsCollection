//
//  BaseNavigationController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/4.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    private var autoRotateEnable = false {
        didSet {
            if #available(iOS 16.0, *) {
                setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.modalPresentationStyle = .fullScreen
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if self.autoRotateEnable {
            return [.all]
        }
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return self.autoRotateEnable
    }
    
    func setAutoRotate(enable: Bool) {
        self.autoRotateEnable = enable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationBar.tintColor = nil
        self.setTranslucent(false)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
        if let vc = viewController as? BaseViewController {
            if let config = vc.getNavigatorConfig() {
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.navigation_return_btn(), style: .plain, target: self, action: #selector(self.onBack))
                self.applyBarConfigs(config: config)
            } else {
                setNavigationBarHidden(true, animated: true)
            }
        } else {
            setNavigationBarHidden(false, animated: true)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.navigation_return_btn(), style: .plain, target: self, action: #selector(self.onBack))
        }
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let vc = super.popToViewController(viewController, animated: animated)
        if let vc = viewController as? BaseViewController {
            self.applyBarConfigs(config: vc.getNavigatorConfig())
        }
        return vc
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let vc = super.popToRootViewController(animated: animated)
        if let vc = topViewController as? BaseViewController {
            self.applyBarConfigs(config: vc.getNavigatorConfig())
        }
        return vc
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        if let vc = topViewController as? BaseViewController {
            self.applyBarConfigs(config: vc.getNavigatorConfig())
        }
        return vc
    }
    
    private func setTranslucent(_ translucent: Bool) {
        let bgColor = UIColor.white
        if #available(iOS 15, *) {
            let app = UINavigationBarAppearance()
            if translucent {
                app.configureWithTransparentBackground()
                app.shadowImage = UIImage()
            } else {
                app.configureWithOpaqueBackground()
                app.backgroundColor = bgColor
            }
            navigationBar.standardAppearance = app
            navigationBar.scrollEdgeAppearance = app
            navigationBar.isTranslucent = translucent
        } else {
            if translucent {
                navigationBar.setBackgroundImage(UIColor.clear.toImage(size: CGSize(width: 1, height: 1)), for: .default)
                navigationBar.shadowImage = UIImage()
                navigationBar.isTranslucent = true
            } else {
                navigationBar.setBackgroundImage(bgColor.toImage(size: CGSize(width: 1, height: 1)), for: .default)
                navigationBar.shadowImage = nil
                navigationBar.isTranslucent = false
            }
        }
    }
    
    private func applyBarConfigs(config: NavigatorConfig?) {
        setNavigationBarHidden(config == nil, animated: true)
        if let cfg = config {
            if cfg.bgColor != nil {
                self.setTranslucent(false)
                navigationBar.backgroundColor = cfg.bgColor
            } else {
                self.setTranslucent(cfg.isTranslucent)
            }
            if cfg.tinColor != nil {
                navigationBar.tintColor = cfg.tinColor
            } else {
                navigationBar.tintColor = .black
            }
            if cfg.title != nil {
                self.setTitle(title: cfg.title!, subTitle: cfg.subTitle)
            }
        }
    }

    /**
     自定义左按钮
     */
    func setLeftBarButton(title: String? = nil, titleAttrs: [NSAttributedString.Key: Any]? = nil, image: UIImage?, action: Selector?) {
        let item = UIBarButtonItem()
        if title != nil {
            item.setBackgroundImage(image, for: .normal, barMetrics: .default)
        } else {
            item.image = image
        }
        item.target = self.topViewController
        item.action = action
        if let title = title {
            item.title = title
            if let attrs = titleAttrs {
                item.setTitleTextAttributes(attrs, for: .normal)
            }
        }
        topViewController?.navigationItem.leftBarButtonItem = item
    }
    
    /**
     自定义右按钮
     */
    func setRightBarButton(title: String? = nil, titleAttrs: [NSAttributedString.Key: Any]? = nil, image: UIImage?, action: Selector?) {
        let item = UIBarButtonItem()
        if title != nil {
            item.setBackgroundImage(image, for: .normal, barMetrics: .default)
        } else {
            item.image = image
        }
        item.target = self.topViewController
        item.action = action
        if let title = title {
            item.title = title
            if let attrs = titleAttrs {
                item.setTitleTextAttributes(attrs, for: .normal)
            }
        }
        topViewController?.navigationItem.rightBarButtonItem = item
    }
    
    /**
     自定义中间标题
     */
    func setTitle(title: String, subTitle: String? = nil, action: Selector? = nil) {
        self.initTitleView(title, subTitle, action)
        topViewController?.navigationItem.title = title
    }
    
    private func initTitleView(_ title: String, _ subTitle: String?, _ action: Selector?) {
        let titleView = UILabel()
        titleView.textColor = .black
        titleView.textAlignment = .center
        titleView.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleView.numberOfLines = 0
        if subTitle != nil, !subTitle!.isEmpty {
            let wholeTitle = title + "\n" + (subTitle ?? "")
            if let range = wholeTitle.range(of: "\n") {
                let title1 = String(wholeTitle[..<range.lowerBound])
                let title2 = String(wholeTitle[range.lowerBound...])
                let attr1 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.3)]
                let attr2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.3)]
                let attrTitle1 = NSMutableAttributedString(string: title1, attributes: attr1)
                let attrTitle2 = NSMutableAttributedString(string: title2, attributes: attr2)
                attrTitle1.append(attrTitle2)
                let paraph = NSMutableParagraphStyle()
                paraph.lineSpacing = 1
                paraph.alignment = .center
                paraph.paragraphSpacingBefore = 0
                paraph.paragraphSpacing = 0
                attrTitle1.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraph, range: NSRange(location: 0, length: wholeTitle.count))
                titleView.attributedText = attrTitle1
            }
            titleView.lineBreakMode = .byWordWrapping
            topViewController?.navigationItem.titleView = titleView
        } else {
            titleView.text = title
            topViewController?.navigationItem.titleView = titleView
        }
        if let act = action {
            topViewController?.navigationItem.titleView?.addGestureRecognizer(UITapGestureRecognizer(target: topViewController, action: act))
        }
    }

    @objc private func onBack() {
        if viewControllers.count > 1 {
            _ = self.popViewController(animated: true)
        } else {
            self.topViewController?.dismiss(animated: true)
        }
    }
}

class NavigatorConfig {
    var isTranslucent = false
    var title: String?
    var subTitle: String?
    var titleSelector: Selector?
    var leftBarButton: BarButtonBean?
    var rightBarButton: BarButtonBean?
    var bgColor: UIColor?
    var tinColor: UIColor?
    
    static func newConfig() -> NavigatorConfig {
        return NavigatorConfig()
    }
    
    func isTranslucent(_ translucent: Bool) -> NavigatorConfig {
        self.isTranslucent = translucent
        return self
    }
    
    func title(title: String, subTitle: String? = nil, action: Selector? = nil) -> NavigatorConfig {
        self.title = title
        self.subTitle = subTitle
        self.titleSelector = action
        return self
    }
    
    func leftBarButton(image: UIImage?, title: String? = nil, titleAttrs: [NSAttributedString.Key: Any]? = nil, action: Selector?) -> NavigatorConfig {
        self.leftBarButton = BarButtonBean()
        self.leftBarButton?.buttonTitle = title
        self.leftBarButton?.buttonTitleAttrs = titleAttrs
        self.leftBarButton?.buttonBg = image
        self.leftBarButton?.buttonSelector = action
        return self
    }
    
    func rightBarButton(image: UIImage?, title: String? = nil, titleAttrs: [NSAttributedString.Key: Any]? = nil, action: Selector) -> NavigatorConfig {
        self.rightBarButton = BarButtonBean()
        self.rightBarButton?.buttonTitle = title
        self.rightBarButton?.buttonTitleAttrs = titleAttrs
        self.rightBarButton?.buttonBg = image
        self.rightBarButton?.buttonSelector = action
        return self
    }
    
    func backgroundColor(color: UIColor) -> NavigatorConfig {
        self.bgColor = color
        return self
    }
    
    func tinColor(color: UIColor) -> NavigatorConfig {
        self.tinColor = color
        return self
    }
    
    class BarButtonBean {
        var buttonBg: UIImage?
        var buttonTitle: String?
        var buttonTitleAttrs: [NSAttributedString.Key: Any]?
        var buttonSelector: Selector?
    }
}
