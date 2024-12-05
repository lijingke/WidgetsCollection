//
//  JKFeedbackViewController.swift
//  OnFit
//
//  Created by 李京珂 on 2024/11/11.
//

import Foundation

class JKFeedbackViewController: BaseViewController {
    // MARK: Property

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        FeedbackViewModel.shared.monitorChange()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FeedbackViewModel.shared.recoveryData()
    }

    override func getNavigatorConfig() -> NavigatorConfig? {
        return nil
    }

    // MARK: Lazy Get

    lazy var mainView: FeedbackView = {
        let view = FeedbackView()
        view.delegate = self
        return view
    }()
}

// MARK: - FeedbackViewDelegate

extension JKFeedbackViewController: FeedbackViewDelegate {
    func submitData() {
        let viewModel = FeedbackViewModel.shared
        if !viewModel.canSumbit {
            Loading.showToast(with: R.string.localizables.feedBackNeedCompleteCopy(), to: view)
            return
        }
        let submitModel = viewModel.getSubmitData()
        Loading.showToast(with: R.string.localizables.feedBackSuccessCopy(), to: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UI

extension JKFeedbackViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
