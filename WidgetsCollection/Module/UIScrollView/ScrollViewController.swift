//
//  ScrollViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2019/10/21.
//  Copyright © 2019 李京珂. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setZoomScale()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // 1.移除子视图
        for view in mainView.subviews {
            view.removeFromSuperview()
        }

        // 2.初始化imageView 将其添加到scrollView 设置contentSize
        imageView = UIImageView(image: UIImage(named: "Van Gogh_Starry Night"))
        mainView.addSubview(imageView)
        mainView.contentSize = imageView.frame.size 
        
        // 3.重设minimumZoomScale
        setZoomScale()
        
    }

    
    fileprivate func configureUI() {
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        mainView.addSubview(imageView)
        view.layoutIfNeeded()
    }
    
    lazy var mainView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.contentSize = self.imageView.frame.size
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.contentOffset = CGPoint(x: 100, y: 0)
//        view.minimumZoomScale = 0.1
//        view.maximumZoomScale = 4
//        view.zoomScale = 1.0
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImage(named: "Van Gogh_Starry Night")
        let view = UIImageView(image: image)
        return view
    }()
}

extension ScrollViewController: UIScrollViewDelegate {
    
    func setZoomScale() {
        let widthScale: CGFloat = mainView.frame.width / imageView.frame.width
        let heightScale: CGFloat = mainView.frame.height / imageView.frame.height
         mainView.minimumZoomScale = min(widthScale, heightScale)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
