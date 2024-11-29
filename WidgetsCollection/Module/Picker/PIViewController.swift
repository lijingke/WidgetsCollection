//
//  PIViewController.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/11/29.
//

import Foundation

class PIViewController: UIViewController {
    
    @IBOutlet var datePicker: PIDatePicker!
    @IBOutlet var label: UILabel!
    
    let validPast: TimeInterval = -10000000000
    
    lazy var btn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("SJDatePicker", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.addTarget(self, action: #selector(self.btnAction), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.minimumDate = Date().addingTimeInterval(self.validPast)
        self.datePicker.delegate = self
        
        view.addSubview(self.btn)
        self.btn.snp.makeConstraints { make in
            make.top.equalTo(self.label.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }

    @IBAction func randomizeColor(_ sender: Any) {
        let red = CGFloat(arc4random_uniform(255))
        let green = CGFloat(arc4random_uniform(255))
        let blue = CGFloat(arc4random_uniform(255))
        
        self.datePicker.textColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        self.datePicker.reloadAllComponents()
    }
    
    @IBAction func randomizeFont(_ sender: Any) {
        let familyNames = UIFont.familyNames
        let randomNumber = Int(arc4random_uniform(UInt32(familyNames.count)))
        let familyName: String = familyNames[randomNumber]
        let fontName: String = UIFont.fontNames(forFamilyName: familyName)[0]
        self.datePicker.font = UIFont(name: fontName, size: 14)!
        self.datePicker.reloadAllComponents()
    }
    
    @objc private func btnAction() {
        let vc = CustomDatePickerVC()
        navigationController?.pushViewController(vc, animated: true)
        
//        let vc = PresentedViewController()
//        navigationController?.present(vc, animated: true)
    }
}

extension PIViewController: PIDatePickerDelegate {
    func pickerView(_ pickerView: PIDatePicker, didSelectRow row: Int, inComponent component: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        self.label.text = dateFormatter.string(from: pickerView.date)
    }
}
