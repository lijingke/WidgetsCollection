//
//  FeedbackRadioCell.swift
//  OnFit
//
//  Created by 李京珂 on 2024/11/11.
//

import Foundation

class FeedbackRadioCell: UITableViewCell {
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
    
    override func draw(_ rect: CGRect) {
        backView.roundCorners(corners: [.topLeft, .topRight], radius: fixSize(40))
    }

    // MARK: Lazy Get
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textFont(size: 18)
        label.textColor = UIColor(hexString: "#333333")
        label.numberOfLines = 0
        return label
    }()

    lazy var layout: UICollectionViewLeftAlignedLayout = {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.sectionInset = UIEdgeInsets(top: fixSize(16), left: fixSize(14), bottom: fixSize(12), right: fixSize(14))
        layout.minimumLineSpacing = fixSize(10)
        layout.minimumInteritemSpacing = fixSize(10)
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
    
    lazy var textView: RSKPlaceholderTextView = {
        let view = RSKPlaceholderTextView()
        view.delegate = self
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "#D2D2D2").cgColor
        view.layer.cornerRadius = 10
        view.attributedPlaceholder = NSAttributedString(string: R.string.localizables.feedBackIssuesTextViewHint(), attributes: [.foregroundColor: UIColor(hexString: "#D0D0D0"), .font: UIFont.textFont(size: 14)])
        view.returnKeyType = .done
        return view
    }()
    
}

// MARK: - UITextViewDelegate

extension FeedbackRadioCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let content = textView.text
        model?.additionalContent = content
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            endEditing(false)
            return false
        }
        return true
    }
}

// MARK: - Data

extension FeedbackRadioCell {
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
            updateHeight()
        }
    }
}
// MARK: - UI

extension FeedbackRadioCell {
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubviews([titleLabel, collectionView, textView])
        backView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(fixSize(38))
            make.left.bottom.right.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(fixSize(24))
            make.left.equalToSuperview().offset(fixSize(24))
            make.right.equalToSuperview().offset(fixSize(-24))
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(fixSize(50))
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.left.equalToSuperview().offset(fixSize(24))
            make.right.equalToSuperview().offset(fixSize(-24))
            make.height.equalTo(fixSize(120))
            make.bottom.equalToSuperview()
        }
    }
}

extension FeedbackRadioCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = model?.radioArr[indexPath.row].value ?? ""
        let width = value.getWidth(UIFont.textFont(size: 15)) + fixSize(20 * 2)
        return CGSize(width: width, height: fixSize(36))
    }
}

// MARK: - UICollectionViewDelegate

extension FeedbackRadioCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let radioItem = model?.radioArr[indexPath.row] else { return }
        model?.radioArr.forEach({ item in
            if item == radioItem {
                item.isSelected = !item.isSelected
                model?.value = item.isSelected ? item.value : nil
            } else {
                item.isSelected = false
            }
        })
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension FeedbackRadioCell: UICollectionViewDataSource {
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
