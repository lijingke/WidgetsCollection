//
//  Helpers.swift
//  Semantic Colors
//
//  Created by Aaron Brethorst on 11/10/19.
//  Copyright © 2019 Cocoa Controls. All rights reserved.
//

import UIKit

// MARK: - UIStackView

public extension UIStackView {
    /// Creates a stack view configured for displaying content vertically.
    /// - Parameter arrangedSubviews: The views to display within the returned stack view.
    static func verticalStack(arrangedSubviews: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = .vertical
        stack.spacing = UIView.defaultPadding
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
}

// MARK: - UIView

public extension UIView {
    static let defaultCornerRadius: CGFloat = 8.0

    static let defaultPadding: CGFloat = 10.0

    static let defaultDirectionalLayoutMargins = NSDirectionalEdgeInsets(top: defaultPadding, leading: defaultPadding, bottom: defaultPadding, trailing: defaultPadding)

    /// Creates a new instance of the receiver class, configured for use with Auto Layout.
    /// - Returns: An instance of the receiver class.
    static func autolayoutNew() -> Self {
        let view = self.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    internal func pinToSuperviewEdges() {
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }

    internal func pinToSuperviewLayoutMargins() {
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor),
            leadingAnchor.constraint(equalTo: superview.layoutMarginsGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.layoutMarginsGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor),
        ])
    }
}
