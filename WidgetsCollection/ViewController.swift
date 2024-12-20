//
//  ViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/11/29.
//

import UIKit

class ViewController: BaseViewController {
    @IBOutlet var helloWorld: UILabel!

    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .random
        
        setupUI()
        
        // Diagonal gradient
        let backgroundGradient = UIImage.gradientImage(
            colors: [UIColor.white, UIColor.darkGray],
            locations: [0.0, 1.0],
            startPoint: CGPoint(),
            endPoint: CGPoint(x: 1.0, y: 1.0),
            size: view.bounds.size
        )

        view.backgroundColor = UIColor(patternImage: backgroundGradient)

        // Horizontal gradient
        let labelGradient = UIImage.gradientImage(
            colors: [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemIndigo, .systemPurple],
            locations: [0.0, 0.14, 0.29, 0.42, 0.57, 0.71, 0.86, 1.0],
            size: helloWorld.bounds.size,
            horizontal: true
        )
        let _ = [UIColor.red, UIColor.green, UIColor.blue, UIColor.red].icg.linearGradient(helloWorld.bounds.size, locations: [0.0, 0.33, 0.66, 1.0], direction: .horizontal)
        helloWorld.textColor = UIColor(patternImage: labelGradient)

        // Vertical gradient
        let _ = UIImage.gradientImage(
            colors: [UIColor.black, UIColor.red],
            locations: [0.0, 1.0],
            size: button.bounds.size
        )

        let image = [UIColor(hexString: "#E969C0"), .systemCyan, UIColor(hexString: "#F763A5")].icg.linearGradient(button.bounds.size, direction: .vertical)
        button.setTitleColor(UIColor(patternImage: image), for: .normal)
        
        bezierPathBtn.setTitleColor(UIColor(patternImage: image), for: .normal)
    }
    
    override func getNavigatorConfig() -> NavigatorConfig? {
        return nil
    }
    
    lazy var bezierPathBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 1
        btn.setTitle("Bezier Path", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        return btn
    }()
}

// MARK: - UI

extension ViewController {
    private func setupUI() {
        view.addSubview(bezierPathBtn)
        bezierPathBtn.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Event

extension ViewController {
    @IBAction @objc func btnAction(_ sender: UIButton) {
        var vc: UIViewController?
        if sender.tag == 0 {
            vc = DateProgressVC()
        }
        if sender.tag == 1 {
            vc = BezierPathVC()
            vc?.title = "Bezier Path"
        }
        if let currentVC = vc {
            navigationController?.pushViewController(currentVC, animated: true)
        }
    }

}
