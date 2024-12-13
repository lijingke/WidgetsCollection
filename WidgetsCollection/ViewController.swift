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
    }
    
    override func getNavigatorConfig() -> NavigatorConfig? {
        return nil
    }
}

// MARK: - Event

extension ViewController {
    @IBAction func btnAction(_ sender: UIButton) {
        let vc = DateProgressVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
