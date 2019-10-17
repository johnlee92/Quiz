//
//  QuizViewReactor.swift
//  Quiz
//
//  Created by 이재현 on 2019/10/17.
//  Copyright © 2019 Jaehyeon Lee. All rights reserved.
//

import ReactorKit
import RxSwift

final class QuizViewReactor: Reactor {
  
  enum Action {
    case showNextQuestion
    case showAnswer
  }
  
  enum Mutation {
    case setCurrentQuestionIndex(Int)
    case setAnswerOpen(Bool)
  }
  
  struct State {
    var currentQuestionIndex: Int = 0
    var isAnswerOpen: Bool = false
  }
  
  let initialState = State()
  
  init() {
    defer { _ = self.state }
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .showAnswer:
      return Observable.just(Mutation.setAnswerOpen(true))
      
    case .showNextQuestion:
      let increasedIndex = currentState.currentQuestionIndex + 1
      let nextIndex = increasedIndex >= Quiz.questions.count ? 0 : increasedIndex
      return Observable.concat([
        Observable.just(Mutation.setCurrentQuestionIndex(nextIndex)),
        Observable.just(Mutation.setAnswerOpen(false))
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setAnswerOpen(isAnswerOpen):
      state.isAnswerOpen = isAnswerOpen
      
    case let .setCurrentQuestionIndex(index):
      state.currentQuestionIndex = index
    }
    return state
  }
}
