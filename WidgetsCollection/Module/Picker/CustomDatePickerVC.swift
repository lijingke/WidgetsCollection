//
//  CustomDatePickerVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/11/29.
//

import Foundation

class CustomDatePickerVC: BaseViewController {
    // MARK: Lazy Get

    lazy var txtShowDate: UITextField = {
        let field = UITextField()
        field.delegate = self
        field.textColor = UIColor(named: "textColor")
        field.backgroundColor = UIColor(named: "backColor")
        field.layer.cornerRadius = 10
        field.textAlignment = .center
        return field
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        view.backgroundColor = UIColor.systemBackground
        txtShowDate.textColor = UIColor(named: "textColor")
        txtShowDate.backgroundColor = UIColor(named: "backColor")

        view.addSubview(txtShowDate)
        txtShowDate.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    // MARK: Private

    private func showPicker() {
        var style = DefaultStyle()
        style.pickerColor = StyleColor.colors([style.textColor, .red, .blue])
        style.pickerMode = .date
        style.titleString = "This is Date Picker"
        style.returnDateFormat = .d_m_yyyy
        style.titleFont = UIFont.systemFont(ofSize: 25, weight: .bold)

        let pick = PresentedViewController()
        pick.style = style
        pick.block = { [weak self] date in
            self?.txtShowDate.text = date
        }
        present(pick, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension CustomDatePickerVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        showPicker()
    }
}
