//
//  ViewController.swift
//  Quiz
//
//  Created by 이재현 on 2019/10/17.
//  Copyright © 2019 Jaehyeon Lee. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class QuizViewController: BaseViewController, View {
  
  // MARK: UI
  
  let questionStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16.f
  }
  
  let answerStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16.f
  }
  
  var currentQuestionLabel = UILabel().then {
    $0.textAlignment = .center
  }
  
  var nextQuestionLabel = UILabel().then {
    $0.alpha = 0.0
    $0.textAlignment = .center
  }
  
  let answerlabel = UILabel().then {
    $0.textAlignment = .center
  }
  
  let nextQuestionButton = UIButton().then {
    $0.setTitle("next question", for: .normal)
    $0.setTitleColor(.systemBlue, for: .normal)
  }
  
  let answerButton = UIButton().then {
    $0.setTitle("show answer", for: .normal)
    $0.setTitleColor(.systemBlue, for: .normal)
  }
  
  // MARK: Initializing
  
  init(reactor: QuizViewReactor) {
    defer { self.reactor = reactor }
    super.init()
  }
  
  required convenience init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(questionStackView)
    view.addSubview(answerStackView)
    view.addSubview(nextQuestionLabel)
    questionStackView.addArrangedSubview(currentQuestionLabel)
    questionStackView.addArrangedSubview(nextQuestionButton)
    answerStackView.addArrangedSubview(answerlabel)
    answerStackView.addArrangedSubview(answerButton)
  }
  
  override func prepareConstraints() {
    questionStackView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().multipliedBy(0.75)
    }
    answerStackView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(questionStackView.snp.bottom).offset(64.f)
    }
    nextQuestionLabel.snp.makeConstraints { make in
      make.center.equalTo(currentQuestionLabel)
    }
  }
  
  // MARK: Binding
  
  func bind(reactor: QuizViewReactor) {
    // Input
    nextQuestionButton.rx.tap
      .map { Reactor.Action.showNextQuestion }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    answerButton.rx.tap
      .map { Reactor.Action.showAnswer }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    // Output
    reactor.state.map { $0.currentQuestionIndex }
      .distinctUntilChanged()
      .map { Quiz.questions[$0] }
      .subscribe(onNext: { [weak self] question in
        guard let `self` = self else { return }
        self.nextQuestionLabel.text = question
        self.nextQuestionLabel.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
          self.nextQuestionLabel.alpha = 1.0
          self.currentQuestionLabel.alpha = 0.0
        }) { _ in swap(&self.nextQuestionLabel, &self.currentQuestionLabel) }
      })
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.isAnswerOpen }
      .distinctUntilChanged()
      .map { $0 ? Quiz.answers[reactor.currentState.currentQuestionIndex] : "???" }
      .bind(to: self.answerlabel.rx.text)
      .disposed(by: self.disposeBag)
  }
}
