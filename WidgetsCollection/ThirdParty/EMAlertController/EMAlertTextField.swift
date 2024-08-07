//
//  EMAlertTextField.swift
//  EMAlertController
//
//  Created by Eduardo Moll on 10/23/17.
//  Copyright © 2017 Eduardo Moll. All rights reserved.
//

import UIKit

protocol Separatable {
    func addSeparator(_ view: UIView)
    func addLeftSeparator(_ view: UIView)
    func addRightSeparator(_ view: UIView)
}

extension Separatable {
    func addSeparator(_ view: UIView) {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.emSeparatorColor.withAlphaComponent(0.4)

        view.addSubview(separator)

        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    func addLeftSeparator(_ view: UIView) {
        let leftSeparator = UIView()
        leftSeparator.translatesAutoresizingMaskIntoConstraints = false
        leftSeparator.backgroundColor = UIColor.emSeparatorColor.withAlphaComponent(0.4)

        view.addSubview(leftSeparator)

        leftSeparator.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        leftSeparator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leftSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        leftSeparator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func addRightSeparator(_ view: UIView) {
        let rightSeparator = UIView()
        rightSeparator.translatesAutoresizingMaskIntoConstraints = false
        rightSeparator.backgroundColor = UIColor.emSeparatorColor.withAlphaComponent(0.4)

        view.addSubview(rightSeparator)

        rightSeparator.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        rightSeparator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rightSeparator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

open class EMAlertTextField: UITextField {
    // MARK: - Initializers

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    public init() {
        super.init(frame: .zero)
        setUp()
    }
}

// MARK: - Setup Methods

extension EMAlertTextField: Separatable {
    fileprivate func setUp() {
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 14)
        returnKeyType = .default
        textAlignment = .center

        addSeparator(self)
    }
}
