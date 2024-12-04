//
//  PIDatePicker.swift
//  Pods
//
//  Created by Christopher Jones on 3/30/15.
//
//

import Foundation
import UIKit

public class PIDatePicker: UIControl, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: -

    // MARK: Public Properties

    public var delegate: PIDatePickerDelegate?

    /// The font for the date picker.

    public var font = UIFont.systemFont(ofSize: 15.0)
    /// The text color for the date picker components.

    public var textColor = UIColor.black
    /// The minimum date to show for the date picker. Set to NSDate.distantPast() by default
    public var minimumDate = Date.distantPast {
        didSet {
            validateMinimumAndMaximumDate()
        }
    }

    /// The maximum date to show for the date picker. Set to NSDate.distantFuture() by default
    public var maximumDate = Date.distantFuture {
        didSet {
            validateMinimumAndMaximumDate()
        }
    }

    /// The current locale to use for formatting the date picker. By default, set to the device's current locale
    public var locale: Locale = .current {
        didSet {
            calendar.locale = locale
        }
    }

    /// The current date value of the date picker.

    public private(set) var date = Date()

    // MARK: -

    // MARK: Private Variables

    private let maximumNumberOfRows = Int(INT16_MAX)

    /// The internal picker view used for laying out the date components.
    private let pickerView = UIPickerView()

    /// The calendar used for formatting dates.

    /// Calculates the current calendar components for the current date.
    private var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    private var currentCalendarComponents: DateComponents {
        return (calendar as NSCalendar).components([.year, .month, .day], from: date)
    }

    /// Gets the text color to be used for the label in a disabled state
    private var disabledTextColor: UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0

        textColor.getRed(&r, green: &g, blue: &b, alpha: nil)

        return UIColor(red: r, green: g, blue: b, alpha: 0.35)
    }

    /// The order in which each component should be ordered in.
    private var datePickerComponentOrdering = [PIDatePickerComponents]()

    // MARK: -

    // MARK: LifeCycle

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    /**
     Handles the common initialization amongst all init()
     */
    func commonInit() {
//        self.locale = Locale(identifier: "en_US")
        pickerView.dataSource = self
        pickerView.delegate = self

        addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: pickerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: pickerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: pickerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)

        addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }

    // MARK: -

    // MARK: Override

    override public var intrinsicContentSize: CGSize {
        return pickerView.intrinsicContentSize
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        reloadAllComponents()

        setDate(date)
    }

    // MARK: -

    // MARK: Public

    /**
     Reloads all of the components in the date picker.
     */
    public func reloadAllComponents() {
        refreshComponentOrdering()
        pickerView.reloadAllComponents()
    }

    /**
     Sets the current date value for the date picker.

     :param: date     The date to set the picker to.
     :param: animated True if the date picker should changed with an animation; otherwise false,
     */
    public func setDate(_ date: Date, animated: Bool) {
        self.date = date
        updatePickerViewComponentValuesAnimated(animated)
    }

    // MARK: -

    // MARK: Private

    /**
     Sets the current date with no animation.

     :param: date The date to be set.
     */
    private func setDate(_ date: Date) {
        setDate(date, animated: false)
    }

    /**
     Creates a new date formatter with the locale and calendar

     :returns: A new instance of NSDateFormatter
     */
    private func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = locale

        return dateFormatter
    }

    /**
     Refreshes the ordering of components based on the current locale. Calling this function will not refresh the picker view.
     */
    private func refreshComponentOrdering() {
        guard var componentOrdering = DateFormatter.dateFormat(fromTemplate: "yMMMMd", options: 0, locale: locale) else {
            return
        }

        let firstComponentOrderingString = componentOrdering[componentOrdering.index(componentOrdering.startIndex, offsetBy: 0)]
        let lastComponentOrderingString = componentOrdering[componentOrdering.index(componentOrdering.startIndex, offsetBy: componentOrdering.count - 1)]

        var characterSet = CharacterSet(charactersIn: String(firstComponentOrderingString) + String(lastComponentOrderingString))
        characterSet = characterSet.union(CharacterSet.whitespacesAndNewlines).union(CharacterSet.punctuationCharacters)

        componentOrdering = componentOrdering.trimmingCharacters(in: characterSet)
        let remainingValue = componentOrdering[componentOrdering.index(componentOrdering.startIndex, offsetBy: 0)]

        guard
            let firstComponent = PIDatePickerComponents(rawValue: firstComponentOrderingString),
            let secondComponent = PIDatePickerComponents(rawValue: remainingValue),
            let lastComponent = PIDatePickerComponents(rawValue: lastComponentOrderingString)
        else {
            return datePickerComponentOrdering = [.year, .month, .day]
        }

        datePickerComponentOrdering = [firstComponent, secondComponent, lastComponent]
    }

    /**
     Validates that the set minimum and maximum dates are valid.
     */
    private func validateMinimumAndMaximumDate() {
        let ordering = minimumDate.compare(maximumDate)
        if ordering != .orderedAscending {
            fatalError("Cannot set a maximum date that is equal or less than the minimum date.")
        }
    }

    /**
     Gets the value of the current component at the specified row.

     :param: row            The row index whose value is required
     :param: componentIndex The component index for the row.

     :returns: A string containing the value of the current row at the component index.
     */
    private func titleForRow(_ row: Int, inComponentIndex componentIndex: Int) -> String {
        let dateComponent = componentAtIndex(componentIndex)

        let value = rawValueForRow(row, inComponent: dateComponent)

        if dateComponent == PIDatePickerComponents.month {
            let dateFormatter = self.dateFormatter()
            return dateFormatter.monthSymbols[value - 1]
        } else {
            return String(value)
        }
    }

    /**
     Gets the value of the input component using the current date.

     :param: component The component whose value is needed.

     :returns: The value of the component.
     */
    private func valueForDateComponent(_ component: PIDatePickerComponents) -> Int {
        if component == .year {
            return currentCalendarComponents.year!
        } else if component == .day {
            return currentCalendarComponents.day!
        } else {
            return currentCalendarComponents.month!
        }
    }

    /**
     Gets the maximum range for the specified date picker component.

     :param: component The component to get the range for.

     :returns: The maximum date range for that component.
     */
    private func maximumRangeForComponent(_ component: PIDatePickerComponents) -> NSRange {
        var calendarUnit: NSCalendar.Unit
        if component == .year {
            calendarUnit = .year
        } else if component == .day {
            calendarUnit = .day
        } else {
            calendarUnit = .month
        }

        return (calendar as NSCalendar).maximumRange(of: calendarUnit)
    }

    /**
     Calculates the raw value of the row at the current index.

     :param: row       The row to get.
     :param: component The component which the row belongs to.

     :returns: The raw value of the row, in integer. Use NSDateComponents to convert to a usable date object.
     */
    private func rawValueForRow(_ row: Int, inComponent component: PIDatePickerComponents) -> Int {
        let calendarUnitRange = maximumRangeForComponent(component)
        return calendarUnitRange.location + (row % calendarUnitRange.length)
    }

    /**
     Checks if the specified row should be enabled or not.

     :param: row       The row to check.
     :param: component The component to check the row in.

     :returns: YES if the row should be enabled; otherwise NO.
     */
    private func isRowEnabled(_ row: Int, forComponent component: PIDatePickerComponents) -> Bool {
        let rawValue = rawValueForRow(row, inComponent: component)

        var components = DateComponents()
        components.year = currentCalendarComponents.year
        components.month = currentCalendarComponents.month
        components.day = currentCalendarComponents.day

        if component == .year {
            components.year = rawValue
        } else if component == .day {
            components.day = rawValue
        } else if component == .month {
            components.month = rawValue
        }

        let dateForRow = calendar.date(from: components)!

        return dateIsInRange(dateForRow)
    }

    /**
     Checks if the input date falls within the date picker's minimum and maximum date ranges.

     :param: date The date to be checked.

     :returns: True if the input date is within range of the minimum and maximum; otherwise false.
     */
    private func dateIsInRange(_ date: Date) -> Bool {
        return minimumDate.compare(date) != ComparisonResult.orderedDescending &&
            maximumDate.compare(date) != ComparisonResult.orderedAscending
    }

    /**
     Updates all of the date picker components to the value of the current date.

     :param: animated True if the update should be animated; otherwise false.
     */
    private func updatePickerViewComponentValuesAnimated(_ animated: Bool) {
        for (_, dateComponent) in datePickerComponentOrdering.enumerated() {
            setIndexOfComponent(dateComponent, animated: animated)
        }
    }

    /**
     Updates the index of the specified component to its relevant value in the current date.

     :param: component The component to be updated.
     :param: animated  True if the update should be animated; otherwise false.
     */
    private func setIndexOfComponent(_ component: PIDatePickerComponents, animated: Bool) {
        setIndexOfComponent(component, toValue: valueForDateComponent(component), animated: animated)
    }

    /**
     Updates the index of the specified component to the input value.

     :param: component The component to be updated.
     :param: value     The value the component should be updated ot.
     :param: animated  True if the update should be animated; otherwise false.
     */
    private func setIndexOfComponent(_ component: PIDatePickerComponents, toValue value: Int, animated: Bool) {
        let componentRange = maximumRangeForComponent(component)

        let idx = (value - componentRange.location)
        let middleIndex = (maximumNumberOfRows / 2) - (maximumNumberOfRows / 2) % componentRange.length + idx

        var componentIndex = 0

        for (index, dateComponent) in datePickerComponentOrdering.enumerated() {
            if dateComponent == component {
                componentIndex = index
            }
        }

        pickerView.selectRow(middleIndex, inComponent: componentIndex, animated: animated)
    }

    /**
     Gets the component type at the current component index.

     :param: index The component index

     :returns: The date picker component type at the index.
     */
    private func componentAtIndex(_ index: Int) -> PIDatePickerComponents {
        return datePickerComponentOrdering[index]
    }

    /**
     Gets the number of days of the specified month in the specified year.

     :param: month The month whose maximum date value is requested.
     :param: year  The year for which the maximum date value is required.

     :returns: The number of days in the month.
     */
    private func numberOfDaysForMonth(_ month: Int, inYear year: Int) -> Int {
        var components = DateComponents()
        components.month = month
        components.day = 1
        components.year = year

        let calendarRange = (calendar as NSCalendar).range(of: .day, in: .month, for: calendar.date(from: components)!)
        let numberOfDaysInMonth = calendarRange.length

        return numberOfDaysInMonth
    }

    /**
     Determines if updating the specified component to the input value would evaluate to a valid date using the current date values.

     :param: value     The value to be updated to.
     :param: component The component whose value should be updated.

     :returns: True if updating the component to the specified value would result in a valid date; otherwise false.
     */
    private func isValidValue(_ value: Int, forComponent component: PIDatePickerComponents) -> Bool {
        if component == .year {
            let numberOfDaysInMonth = numberOfDaysForMonth(currentCalendarComponents.month!, inYear: value)
            return currentCalendarComponents.day! <= numberOfDaysInMonth
        } else if component == .day {
            let numberOfDaysInMonth = numberOfDaysForMonth(currentCalendarComponents.month!, inYear: currentCalendarComponents.year!)
            return value <= numberOfDaysInMonth
        } else if component == .month {
            let numberOfDaysInMonth = numberOfDaysForMonth(value, inYear: currentCalendarComponents.year!)
            return currentCalendarComponents.day! <= numberOfDaysInMonth
        }

        return true
    }

    /**
     Creates date components by updating the specified component to the input value. This does not do any date validation.

     :param: component The component to be updated.
     :param: value     The value the component should be updated to.

     :returns: The components by updating the current date's components to the specified value.
     */
    private func currentCalendarComponentsByUpdatingComponent(_ component: PIDatePickerComponents, toValue value: Int) -> DateComponents {
        var components = currentCalendarComponents

        if component == .month {
            components.month = value
        } else if component == .day {
            components.day = value
        } else {
            components.year = value
        }

        return components
    }

    /**
     Creates date components by updating the specified component to the input value. If the resulting value is not a valid date object, the components will be updated to the closest best value.

     :param: component The component to be updated.
     :param: value     The value the component should be updated to.

     :returns: The components by updating the specified value; the components will be a valid date object.
     */
    private func validDateValueByUpdatingComponent(_ component: PIDatePickerComponents, toValue value: Int) -> DateComponents {
        var components = currentCalendarComponentsByUpdatingComponent(component, toValue: value)
        if !isValidValue(value, forComponent: component) {
            if component == .month {
                components.day = numberOfDaysForMonth(value, inYear: components.year!)
            } else if component == .day {
                components.day = numberOfDaysForMonth(components.month!, inYear: components.year!)
            } else {
                components.day = numberOfDaysForMonth(components.month!, inYear: value)
            }
        }

        return components
    }

    // MARK: -

    // MARK: Protocols

    // MARK: UIPickerViewDelegate

    public func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let datePickerComponent = componentAtIndex(component)
        let value = rawValueForRow(row, inComponent: datePickerComponent)

        // Create the newest valid date components.
        let components = validDateValueByUpdatingComponent(datePickerComponent, toValue: value)

        // If the resulting components are not in the date range ...
        if !dateIsInRange(calendar.date(from: components)!) {
            // ... go back to original date
            setDate(date, animated: true)
        } else {
            // Get the components that would result by just force-updating the current components.
            let rawComponents = currentCalendarComponentsByUpdatingComponent(datePickerComponent, toValue: value)

            let day = components.day!

            if rawComponents.day != components.day {
                // Only animate the change if the day value is not a valid date.
                setIndexOfComponent(.day, toValue: day, animated: isValidValue(day, forComponent: .day))
            }

            if rawComponents.month != components.month {
                setIndexOfComponent(.month, toValue: day, animated: datePickerComponent != .month)
            }

            if rawComponents.year != components.year {
                setIndexOfComponent(.year, toValue: day, animated: datePickerComponent != .year)
            }

            date = calendar.date(from: components)!
            sendActions(for: .valueChanged)
        }

        delegate?.pickerView(self, didSelectRow: row, inComponent: component)
    }

    public func pickerView(_: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel == nil ? UILabel() : view as! UILabel

        label.font = font
        label.textColor = textColor
        label.text = titleForRow(row, inComponentIndex: component)
//        label.textAlignment = self.componentAtIndex(component) == .month ? NSTextAlignment.left : NSTextAlignment.right
//        switch component {
//        case 0:
//            label.textAlignment = .left
//        case 1:
//            label.textAlignment = .center
//        case 2:
//            label.textAlignment = .right
//        default:
//            label.textAlignment = .center
//        }
        label.textAlignment = .center

        label.textColor = isRowEnabled(row, forComponent: componentAtIndex(component)) ? textColor : disabledTextColor

        return label
    }

    public func pickerView(_: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let widthBuffer = 25.0

        let calendarComponent = componentAtIndex(component)
        let stringSizingAttributes = [NSAttributedString.Key.font: font]
        var size = 0.01

        if calendarComponent == .month {
            let dateFormatter = self.dateFormatter()

            // Get the length of the longest month string and set the size to it.
            for symbol in dateFormatter.monthSymbols {
                let monthSize = NSString(string: symbol).size(withAttributes: stringSizingAttributes)
                size = max(size, Double(monthSize.width))
            }
        } else if calendarComponent == .day {
            // Pad the day string to two digits
            let dayComponentSizingString = NSString(string: "00")
            size = Double(dayComponentSizingString.size(withAttributes: stringSizingAttributes).width)
        } else if calendarComponent == .year {
            // Pad the year string to four digits.
            let yearComponentSizingString = NSString(string: "00")
            size = Double(yearComponentSizingString.size(withAttributes: stringSizingAttributes).width)
        }

        // Add the width buffer in order to allow the picker components not to run up against the edges
        return CGFloat(size + widthBuffer)
    }

    // MARK: UIPickerViewDataSource

    public func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return maximumNumberOfRows
    }

    public func numberOfComponents(in _: UIPickerView) -> Int {
        return 3
    }
}
