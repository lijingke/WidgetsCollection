//
//  FinishAnimationViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2020/8/25.
//  Copyright © 2020 李京珂. All rights reserved.
//

import Foundation
import UIKit

class FinishAnimationViewController: UIViewController {
    // MARK: Property

    let kProgressBarHeight: CGFloat = 38
    let kProgressBarWidth: CGFloat = 150

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let frame = CGRect(x: (UIScreen.main.bounds.width - kProgressBarWidth) / 2, y: (UIScreen.main.bounds.height - kProgressBarHeight) / 2, width: kProgressBarWidth, height: kProgressBarHeight)
        let progressBar = ProgressBarView(frame: frame)
        view.addSubview(progressBar)
        progressBar.backgroundColor = SWColor.indigo
        progressBar.layer.cornerRadius = progressBar.bounds.height / 2
    }
}
