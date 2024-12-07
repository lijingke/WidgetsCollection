//
//  ViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/11/29.
//

import UIKit

class ViewController: UIViewController {
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
            colors: [UIColor.red, UIColor.green, UIColor.blue, UIColor.red],
            locations: [0.0, 0.33, 0.66, 1.0],
            size: helloWorld.bounds.size,
            horizontal: true
        )
        let gradientImage = [UIColor.red, UIColor.green, UIColor.blue, UIColor.red].icg.linearGradient(helloWorld.bounds.size, locations: [0.0, 0.33, 0.66, 1.0], direction: .horizontal)
        helloWorld.textColor = UIColor(patternImage: labelGradient)

        // Vertical gradient
        let buttonGradient = UIImage.gradientImage(
            colors: [UIColor.black, UIColor.red],
            locations: [0.0, 1.0],
            size: button.bounds.size
        )
//            .color(hex: "#E969C0"),.color(hex: "#F763A5")

        let image = [UIColor(hexString: "#E969C0"), UIColor.white, UIColor(hexString: "#F763A5")].icg.linearGradient(button.bounds.size, direction: .vertical)
        button.setTitleColor(UIColor(patternImage: image), for: .normal)
    }
}
