//
//  VisualActivityViewController.swift
//  VisualExample
//
//  Created by Ryan Ackermann on 5/19/18.
//  Copyright © 2018 Ryan Ackermann. All rights reserved.
//

import UIKit

@objcMembers final class VisualActivityViewController: UIActivityViewController {
    /// The preview container view
    private var preview: UIVisualEffectView!

    /// Internal storage of the activity items
    private let activityItems: [Any]

    // MARK: - Configuration

    /// The duration for the preview fading in
    var fadeInDuration: TimeInterval = 0.3

    /// The duration for the preview fading out
    var fadeOutDuration: TimeInterval = 0.3

    /// The corner radius of the preview
    var previewCornerRadius: CGFloat = 12

    /// The corner radius of the preview image
    var previewImageCornerRadius: CGFloat = 3

    /// The side length of the preview image
    var previewImageSideLength: CGFloat = 80

    /// The padding around the preview
    var previewPadding: CGFloat = 12

    /// The number of lines to preview
    var previewNumberOfLines: Int = 5

    /// The preview color for URL activity items
    var previewLinkColor: UIColor = .init(red: 0, green: 0.47, blue: 1, alpha: 1)

    /// The font for the preview label
    var previewFont: UIFont = .systemFont(ofSize: 18)

    /// The margin from the top of the viewController's superview
    var previewTopMargin: CGFloat = 8

    /// The margin from the top of the viewController's view
    var previewBottomMargin: CGFloat = 8

    // MARK: - Init

    convenience init(activityItems: [Any]) {
        self.init(activityItems: activityItems, applicationActivities: nil)
    }

    convenience init(text: String, activities: [UIActivity]? = nil) {
        self.init(activityItems: [text], applicationActivities: activities)
    }

    convenience init(image: UIImage, activities: [UIActivity]? = nil) {
        self.init(activityItems: [image], applicationActivities: activities)
    }

    convenience init(url: URL, activities: [UIActivity]? = nil) {
        self.init(activityItems: [url], applicationActivities: activities)
    }

    override init(activityItems: [Any], applicationActivities: [UIActivity]?) {
        self.activityItems = activityItems

        super.init(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        preview = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.layer.cornerRadius = previewCornerRadius
        preview.clipsToBounds = true
        preview.alpha = 0

        let previewLabel = UILabel()
        previewLabel.translatesAutoresizingMaskIntoConstraints = false
        previewLabel.numberOfLines = previewNumberOfLines

        let attributedString = NSMutableAttributedString()
        let baseAttributes: [NSAttributedString.Key: Any] = [.font: previewFont]

        for (index, item) in activityItems.enumerated() {
            if index > 0 && attributedString.length > 0 && (item is String || item is URL) {
                attributedString.append(NSAttributedString(string: "\n"))
            }

            if let url = item as? URL {
                var urlAttributes = baseAttributes
                urlAttributes[.foregroundColor] = previewLinkColor
                attributedString.append(NSAttributedString(string: url.absoluteString, attributes: urlAttributes))
            } else if let text = item as? String {
                attributedString.append(NSAttributedString(string: text, attributes: baseAttributes))
            }
        }

        previewLabel.attributedText = attributedString

        preview.contentView.addSubview(previewLabel)
        var constraints = [
            previewLabel.topAnchor.constraint(equalTo: preview.topAnchor, constant: previewPadding),
            previewLabel.trailingAnchor.constraint(equalTo: preview.trailingAnchor, constant: -previewPadding),
            previewLabel.bottomAnchor.constraint(equalTo: preview.bottomAnchor, constant: -previewPadding),
        ]

        if let previewImage = activityItems.first(where: { $0 is UIImage }) as? UIImage {
            let previewImageView = UIImageView(image: previewImage)
            previewImageView.translatesAutoresizingMaskIntoConstraints = false
            previewImageView.layer.cornerRadius = previewImageCornerRadius
            previewImageView.contentMode = .scaleAspectFill
            previewImageView.clipsToBounds = true

            if #available(iOS 11.0, *) {
                previewImageView.accessibilityIgnoresInvertColors = true
            }

            preview.contentView.addSubview(previewImageView)
            constraints.append(contentsOf: [
                previewImageView.widthAnchor.constraint(equalTo: previewImageView.heightAnchor),
                previewImageView.heightAnchor.constraint(lessThanOrEqualToConstant: previewImageSideLength),
                previewImageView.topAnchor.constraint(equalTo: preview.topAnchor, constant: previewPadding),
                previewImageView.leadingAnchor.constraint(equalTo: preview.leadingAnchor, constant: previewPadding),
                previewLabel.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: previewPadding),
                previewImageView.bottomAnchor.constraint(lessThanOrEqualTo: preview.bottomAnchor, constant: -previewPadding),
            ])
        } else {
            constraints.append(previewLabel.leadingAnchor.constraint(equalTo: preview.leadingAnchor, constant: previewPadding))
        }

        NSLayoutConstraint.activate(constraints)

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = .down
        preview.addGestureRecognizer(swipeGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        guard let superview = isPad ? presentingViewController?.view : view.superview else {
            return
        }

        superview.addSubview(preview)

        let topAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topAnchor = superview.safeAreaLayoutGuide.topAnchor
        } else {
            topAnchor = superview.topAnchor
        }

        let constraints = [
            preview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            preview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            preview.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -previewBottomMargin),
            preview.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: previewTopMargin),
        ]
        NSLayoutConstraint.activate(constraints)

        UIView.animate(withDuration: fadeInDuration) {
            self.preview.alpha = 1
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: fadeOutDuration, animations: {
            self.preview?.alpha = 0
        }) { _ in
            self.preview?.removeFromSuperview()
        }
    }

    // MARK: - Actions

    @objc private func handleSwipe(_: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
