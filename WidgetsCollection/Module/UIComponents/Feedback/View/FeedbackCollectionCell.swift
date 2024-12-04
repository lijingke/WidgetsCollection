//
//  FeedbackCollectionCell.swift
//  OnFit
//
//  Created by 李京珂 on 2024/11/11.
//

import Foundation
let shortBound: CGFloat = {
    return isLandscape() ? sScreenHeight : sScreenWidth
}()
var sScreenHeight: CGFloat { return UIScreen.main.bounds.size.height }
var sScreenWidth: CGFloat { return UIScreen.main.bounds.size.width }
func isLandscape() -> Bool {
    if #available(iOS 13.0, *) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.interfaceOrientation == .landscapeLeft || windowScene.interfaceOrientation == .landscapeRight
        }
    }
    return UIDevice.current.orientation.isLandscape
}

func fixSize(_ size: CGFloat, _ isRound: Bool = false) -> CGFloat {
    var size = size * shortBound / 390
    if isRound {
        let roundSize = roundf(Float(size))
        size = CGFloat(roundSize)
    }
    return size
}

enum FontName: String {
    case medium = "FiraGO-Medium"
    case regular = "FiraGO-Regular"
    case semiBold = "FiraGO-SemiBold"
    case bold = "FiraGO-Bold"
}

extension UIFont {
    class func textFont(size: CGFloat, fontName: FontName? = .medium) -> UIFont {
        if let name = fontName?.rawValue {
            let font = UIFont(name: name, size: fixSize(size)) ?? UIFont.systemFont(ofSize: fixSize(size))
            //                print("my font ===============================")
            //                UIFont.familyNames.forEach { name in
            //                    print("my font: \(name)")
            //                }
            return font
        }
        return textFont(size: size)
    }
}

class FeedbackCollectionCell: UICollectionViewCell {
    
    // MARK: Property
    var model: FeedbackRadioItem?
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy Get
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textFont(size: 14)
        label.textColor = UIColor(hexString: "#3F3654")
        label.textAlignment = .center
        return label
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        return view
    }()
}

// MARK: - UI
extension FeedbackCollectionCell {
    private func setupUI() {
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(fixSize(20))
            make.right.equalToSuperview().offset(fixSize(-20))
        }
    }
}

// MARK: - Data
extension FeedbackCollectionCell {
    func setupData(_ model: FeedbackRadioItem) {
        self.model = model
        titleLabel.text = model.value
        titleLabel.textColor = model.isSelected ? .white : UIColor(hexString: "#3F3654")
        titleLabel.font = model.isSelected ? UIFont.textFont(size: 14) : UIFont.textFont(size: 14, fontName: .regular)
        backView.backgroundColor = model.isSelected ? UIColor(hexString: "#FB549F") : UIColor(hexString: "#F5F5F7")
    }
}
