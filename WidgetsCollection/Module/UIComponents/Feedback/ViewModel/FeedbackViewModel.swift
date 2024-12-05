//
//  FeedbackViewModel.swift
//  OnFit
//
//  Created by 李京珂 on 2024/11/11.
//

import Foundation
import Combine

class FeedbackViewModel {
    
    static var shared = FeedbackViewModel()
    var dataSource: [FeedbackItemModel] = []
    var cancelable: Set<AnyCancellable> = []
    
    @Published var canSumbit: Bool = false

    init() {
        generateData()
    }
    
    func monitorChange() {
        let issuesModel = dataSource.filter({$0.tag == 0}).first
        let questionnaireModel = dataSource.filter({$0.tag == 1}).first
        if let issues = issuesModel, let questionnaire = questionnaireModel {
            issues.$value.combineLatest(questionnaire.$value).sink { [weak self] value1, value2 in
                if let issuesValue = value1, let questionnaireValue = value2 {
                    self?.canSumbit = issuesValue.count > 0 && questionnaireValue.count > 0
                } else {
                    self?.canSumbit = false
                }
            }.store(in: &cancelable)
        }
    }
    
    func generateData() {
        let issuesModel = FeedbackItemModel()
        issuesModel.tag = 0
        issuesModel.type = .radioButton
        issuesModel.title = R.string.localizables.feedBackIssuesTitle()
        let issuesArr = [R.string.localizables.feedBackIssuesRadio1(), R.string.localizables.feedBackIssuesRadio2(), R.string.localizables.feedBackIssuesRadio3(), R.string.localizables.feedBackIssuesRadio4()]
        issuesModel.radioArr = issuesArr.compactMap({FeedbackRadioItem(value: $0)})
        issuesModel.placeHolder = R.string.localizables.feedBackIssuesTextViewHint()
        
        let questionnaireModel = FeedbackItemModel()
        questionnaireModel.tag = 1
        questionnaireModel.type = .redioButtonAndField
        questionnaireModel.title = R.string.localizables.feedBackQuestionnaireTitle()
        let questionnaireArr = [R.string.localizables.feedBackQuestionnaireRadio1(), R.string.localizables.feedBackQuestionnaireRadio2(), R.string.localizables.feedBackQuestionnaireRadio3(), R.string.localizables.feedBackQuestionnaireRadio4(), R.string.localizables.feedBackQuestionnaireRadio5(), R.string.localizables.feedBackQuestionnaireRadio6(), R.string.localizables.feedBackQuestionnaireRadio7()]
        questionnaireModel.radioArr = questionnaireArr.compactMap({FeedbackRadioItem(value: $0)}).map({ item in
            if item.value == R.string.localizables.feedBackQuestionnaireRadio1() {
                item.isSelected = true
                questionnaireModel.value = item.value
            }
            return item
        })
        
        let emailModel = FeedbackItemModel()
        emailModel.tag = 2
        emailModel.type = .textFiled
        emailModel.title = R.string.localizables.feedBackEmailTitle()
        
        dataSource = [issuesModel, questionnaireModel, emailModel]
    }
    
    func getSubmitData() -> FeedbackCommitModel {
        let submitModel = FeedbackCommitModel()
        let issuesModel = dataSource.filter({$0.tag == 0}).first
        let questionnaireModel = dataSource.filter({$0.tag == 1}).first
        let emailModel = dataSource.filter({$0.tag == 2}).first

        submitModel.issueContent = issuesModel?.value
        submitModel.issue_description = issuesModel?.additionalContent
        submitModel.fitness_content = questionnaireModel?.value
        submitModel.other_content = questionnaireModel?.additionalContent
        submitModel.email = emailModel?.value
        return submitModel
    }
    
    
    func recoveryData() {
        generateData()
    }
}
