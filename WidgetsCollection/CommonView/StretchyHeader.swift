//
//  StretchyHeader.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/11/14.
//

import Foundation
import UIKit

class StretchyTableHeaderView: UIView {
    var imageViewHeight = NSLayoutConstraint()
    var imageViewBottom = NSLayoutConstraint()

    var containerView: UIView!
    var imageView: UIImageView!

    var containerViewHeight = NSLayoutConstraint()

    override init(frame: CGRect) {
        super.init(frame: frame)

        createViews()
        setViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func createViews() {
        // Container View
        containerView = UIView()
        addSubview(containerView)

        // ImageView for background
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .yellow
        imageView.contentMode = .scaleAspectFill
        containerView.addSubview(imageView)
    }

    func setViewConstraints() {
        // UIView Constraints
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor),
        ])

        // Container View Constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: heightAnchor)
        containerViewHeight.isActive = true

        // ImageView Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentInset.top)

        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
