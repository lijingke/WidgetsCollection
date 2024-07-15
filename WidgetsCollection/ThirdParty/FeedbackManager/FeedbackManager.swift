//
//  FeedbackManager.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/7/15.
//

import Foundation

class FeedbackManager {
    static let shared = FeedbackManager()

    fileprivate let pinpointKit = PinpointKit(feedbackRecipients: ["lijingke@hotmail.com"])

    func showView() {
        let currentVC = CommonUtil.getCurrentVc()
        pinpointKit.show(from: currentVC)
    }
}
