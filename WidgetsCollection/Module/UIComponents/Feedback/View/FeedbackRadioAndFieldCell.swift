//
//  FeedbackRadioAndFieldCell.swift
//  OnFit
//
//  Created by 李京珂 on 2024/11/13.
//

import Foundation
import SnapKit

class FeedbackRadioAndFieldCell: UITableViewCell {
    // MARK: Property

    var model: FeedbackItemModel?
    var bottomConstraint: Constraint?
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
        label.numberOfLines = 0
        return label
    }()

    lazy var layout: UICollectionViewLeftAlignedLayout = {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.sectionInset = UIEdgeInsets(top: fixSize(16), left: fixSize(24), bottom: fixSize(12), right: fixSize(24))
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(FeedbackCollectionCell.self, forCellWithReuseIdentifier: FeedbackCollectionCell.identifier)
        view.isScrollEnabled = false
        return view
    }()

    lazy var textField: UITextField = {
        let field = UITextField()
        field.textColor = UIColor(hexString: "#3F3654")
        field.font = UIFont.textFont(size: 14)
        field.delegate = self
        field.isHidden = true
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor(hexString: "#D2D2D2").cgColor
        field.layer.cornerRadius = 10
        field.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: fixSize(10), height: fixSize(10))))
        field.leftViewMode = .always
        field.returnKeyType = .done
        return field
    }()
}

// MARK: - UITextFieldDelegate

extension FeedbackRadioAndFieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        model?.additionalContent = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Data

extension FeedbackRadioAndFieldCell {
    func setupData(_ model: FeedbackItemModel, updateHeight: @escaping (() -> Void)) {
        self.model = model
        titleLabel.text = model.title
        collectionView.reloadData()

        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            let height = weakSelf.collectionView.collectionViewLayout.collectionViewContentSize.height
            weakSelf.collectionView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            weakSelf.textField.isHidden = !model.showOtherInputField
            weakSelf.textField.snp.updateConstraints { make in
                make.height.equalTo(model.showOtherInputField ? fixSize(42) : 0)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, animations: {
                weakSelf.setNeedsLayout()
                updateHeight()
            })
            
        }
    }
}

// MARK: - UI

extension FeedbackRadioAndFieldCell {
    private func setupUI() {
        contentView.addSubviews([titleLabel, collectionView, textField])
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(fixSize(24))
            make.right.equalToSuperview().offset(fixSize(-24))
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(fixSize(50))
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.left.equalToSuperview().offset(fixSize(24))
            make.right.equalToSuperview().offset(fixSize(-24))
            make.height.equalTo(fixSize(0))
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedbackRadioAndFieldCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = model?.radioArr[indexPath.row].value ?? ""
        let width = value.getWidth(UIFont.textFont(size: 15)) + fixSize(20 * 2)
        return CGSize(width: width, height: fixSize(36))
    }
}

// MARK: - UICollectionViewDelegate

extension FeedbackRadioAndFieldCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let radioItem = model?.radioArr[indexPath.row] else { return }
        model?.radioArr.forEach { item in
            if item == radioItem {
                item.isSelected = !item.isSelected
                model?.value = item.isSelected ? item.value : nil
                model?.additionalContent = item.isSelected ? model?.additionalContent : nil

            } else {
                item.isSelected = false
                model?.additionalContent = nil
            }
        }
        model?.showOtherInputField = radioItem.isSelected && radioItem.value == R.string.localizables.feedBackQuestionnaireRadio7()
        NotificationUtils.post(name: "sMsgRefreshFeedbackView")        
    }
}

// MARK: - UICollectionViewDataSource

extension FeedbackRadioAndFieldCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.radioArr.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedbackCollectionCell.identifier, for: indexPath) as! FeedbackCollectionCell
        if let radioItem = model?.radioArr[indexPath.row] {
            cell.setupData(radioItem)
        }
        return cell
    }
}
