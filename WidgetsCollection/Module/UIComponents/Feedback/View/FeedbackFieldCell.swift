//
//  FeedbackFieldCell.swift
//  OnFit
//
//  Created by 李京珂 on 2024/11/11.
//

import Foundation

class FeedbackFieldCell: UITableViewCell {
    // MARK: Property

    var model: FeedbackItemModel?

    // MARK: Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lazy Get

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textFont(size: 18)
        label.textColor = UIColor(hexString: "#333333")
        return label
    }()

    lazy var textField: UITextField = {
        let field = UITextField()
        field.textColor = UIColor(hexString: "#3F3654")
        field.font = UIFont.textFont(size: 14)
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor(hexString: "#D2D2D2").cgColor
        field.keyboardType = .emailAddress
        field.delegate = self
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        field.returnKeyType = .done
        field.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: fixSize(10), height: fixSize(10))))
        field.leftViewMode = .always
        field.returnKeyType = .done
        field.attributedPlaceholder = NSAttributedString(string: R.string.localizables.feedBackHelpUsCopy(), attributes: [.font: UIFont.textFont(size: 14), .foregroundColor: UIColor(hexString: "#D0D0D0")])
        return field
    }()
}

// MARK: - Data

extension FeedbackFieldCell {
    func setupData(_ model: FeedbackItemModel) {
        self.model = model
        titleLabel.text = model.title
    }
}

// MARK: - UITextFieldDelegate

extension FeedbackFieldCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {}

    @objc private func textFieldDidChange(_ textField: UITextField) {
//        let inputText = textField.text ?? ""
//        let isValidate = RegexCheckingTool.validateEmail(email: inputText)
//        let canSubmit = isValidate && inputText.count > 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        model?.value = textField.text
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("----信息----", textField.text!, string.count)
        // 长度限制 , string = 0  点击删除键盘
        if textField.text!.count >= 50 && string.count != 0 {
            return false
        }
        return true
    }
}

// MARK: - UI

extension FeedbackFieldCell {
    private func setupUI() {
        contentView.addSubviews([titleLabel, textField])
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(fixSize(24))
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(fixSize(16))
            make.left.equalToSuperview().offset(fixSize(24))
            make.right.equalToSuperview().offset(fixSize(-24))
            make.height.equalTo(fixSize(42))
            make.bottom.equalToSuperview()
        }
    }
}
