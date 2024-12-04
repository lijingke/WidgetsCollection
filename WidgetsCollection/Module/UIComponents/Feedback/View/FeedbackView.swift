//
//  FeedbackView.swift
//  OnFit
//
//  Created by 李京珂 on 2024/11/11.
//

import Combine
import CoreGraphics
import Foundation

protocol FeedbackViewDelegate: NSObjectProtocol {
    func submitData()
}

class FeedbackView: UIView {
    // MARK: Property

    weak var delegate: FeedbackViewDelegate?
    var cancellable: Set<AnyCancellable> = []
    var viewModel = FeedbackViewModel.shared

    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindData()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lazy Get

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.textFont(size: 18)
        label.text = R.string.localizables.feedBackTitle()
        return label
    }()

    private lazy var naviBg = {
        let v = UIView()
        v.backgroundColor = .white
        v.alpha = 0
        return v
    }()

    private lazy var btnBack = {
        let v = UIButton()
        v.setImage(R.image.feedback_back_icon(), for: .normal)
        v.addTarget(self, action: #selector(onBackClicked), for: .touchUpInside)
        return v
    }()

    lazy var headerView: StretchyTableHeaderView = {
        let view = StretchyTableHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: sScreenWidth, height: 281)))
        view.contentMode = .scaleAspectFit
        view.imageView.image = R.image.feedback_bg()
        view.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(fixSize(112))
            make.left.equalToSuperview().offset(fixSize(36))
            make.right.equalToSuperview().offset(fixSize(-36))
        }
        return view
    }()

    lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizables.feedBackHintCopy()
        label.textColor = .white
        label.font = UIFont.textFont(size: 28, fontName: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
//        label.setShadow(color: UIColor(hexString: "#000000", withAlpha: 0.56), radius: fixSize(8), offset: CGSize(width: 0, height: fixSize(2)))
        return label
    }()

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
        let header = UIView(frame: CGRect(origin: .zero, size: CGSize(width: sScreenWidth, height: 200)))
        header.addSubview(headerView)
        header.layer.zPosition = -1
        table.tableHeaderView = header
        table.register(FeedbackRadioCell.self, forCellReuseIdentifier: FeedbackRadioCell.identifier)
        table.register(FeedbackRadioAndFieldCell.self, forCellReuseIdentifier: FeedbackRadioAndFieldCell.identifier)
        table.register(FeedbackFieldCell.self, forCellReuseIdentifier: FeedbackFieldCell.identifier)
        table.separatorStyle = .none
        table.tableFooterView = submitView
        table.keyboardDismissMode = .onDrag
        table.estimatedSectionFooterHeight = 0
        table.estimatedSectionHeaderHeight = 0
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()

    lazy var submitView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: sScreenWidth, height: 134)))
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(fixSize(30))
            make.left.equalToSuperview().offset(fixSize(36))
            make.right.equalToSuperview().offset(fixSize(-36))
            make.height.equalTo(fixSize(56))
        }
        return view
    }()

    lazy var submitBtn: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setTitle(R.string.localizables.feedBackSubmitTitle(), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 14
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(sumbit), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(color: UIColor(hexString: "#aaaaaa")), for: .normal)
        btn.titleLabel?.font = UIFont.textFont(size: 20)
        return btn
    }()
}

// MARK: - Event

extension FeedbackView {
    private func bindData() {
//        viewModel.$canSumbit.assign(to: \.isEnabled, on: submitBtn).store(in: &cancelable)
        NotificationUtils.publisher(name: "sMsgRefreshFeedbackView").sink { [weak self] _ in
            guard let weakSelf = self else { return }
            let model = weakSelf.viewModel.dataSource[1]
            let cell = weakSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? FeedbackRadioAndFieldCell
            cell?.setupData(model, updateHeight: {
                weakSelf.tableView.beginUpdates()
                weakSelf.tableView.endUpdates()
            })
        }.store(in: &cancellable)

        viewModel.$canSumbit.sink { [weak self] canSubmit in
            let image = UIImage(color: UIColor(hexString: canSubmit ? "#3f3653" : "#aaaaaa"))
            self?.submitBtn.setBackgroundImage(image, for: .normal)
        }.store(in: &cancellable)
    }

    @objc private func onBackClicked() {
//        NaviTool.getCurrentVc().navigationController?.popViewController(animated: true)
    }

    @objc private func sumbit() {
        delegate?.submitData()
    }
}

// MARK: - UITableViewDelegate

extension FeedbackView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == viewModel.dataSource.count - 1 {
            return 0
        }
        return 30
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return viewModel.dataSource[2].showOtherInputField ? 340 : 298
        }
        return 250
    }
}

// MARK: - UITableViewDataSource

extension FeedbackView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.dataSource[indexPath.section]
        if model.type == .radioButton {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackRadioCell.identifier, for: indexPath) as! FeedbackRadioCell
            cell.setupData(model) {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
        }
        if model.type == .redioButtonAndField {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackRadioAndFieldCell.identifier, for: indexPath) as! FeedbackRadioAndFieldCell
            cell.setupData(model) {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
        }
        if model.type == .textFiled {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackFieldCell.identifier, for: indexPath) as! FeedbackFieldCell
            cell.setupData(model)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UIScrollViewDelegate

extension FeedbackView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        Log.info("当前滚动偏移量：\(offset)")
        if offset.y >= fixSize(60), offset.y <= fixSize(140) {
            naviBg.alpha = max(0, min(1, (offset.y - 60) / (140 - 60)))
        } else if offset.y < fixSize(60) {
            naviBg.alpha = 0
        } else if offset.y > fixSize(140) {
            naviBg.alpha = 1
        }
        let color = UIColor.progressColor(forProgress: naviBg.alpha) ?? .white
//        let color = UIColor.progressColor(forProgress: naviBg.alpha, startColor: UIColor.yellow.hexString, endColor: UIColor.green.hexString) ?? .white
        titleLabel.textColor = color
        btnBack.setImage(R.image.feedback_back_icon()?.withTintColor(color), for: .normal)
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}

// MARK: - UI

extension FeedbackView {
    private func setupUI() {
        backgroundColor = .white
        addSubviews([tableView, naviBg, titleLabel, btnBack])
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(btnBack)
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        naviBg.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(fixSize(96))
        }
        btnBack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(fixSize(16))
            make.bottom.equalTo(naviBg.snp.bottom).offset(-fixSize(5))
            make.width.height.equalTo(fixSize(32))
        }
    }
}
