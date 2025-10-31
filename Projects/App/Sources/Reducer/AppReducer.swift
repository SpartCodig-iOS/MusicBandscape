//
//  AppReducer.swift
//  MusicBandscape
//
//  Created by Wonji Suh  on 10/22/25.
//

import ComposableArchitecture
import SwiftUI
import Presentation

@Reducer
struct AppReducer {

  @ObservableState
  enum State {
    case splash(SplashReducer.State)
    case home(HomeCoordinator.State)

    init() {
      self = .splash(.init())
    }
  }

  enum Action: ViewAction {
    case view(View)
    case scope(ScopeAction)
  }

  @CasePathable
  enum View {
    case presentMain
  }

  @CasePathable
  enum ScopeAction {
    case splash(SplashReducer.Action)
    case home(HomeCoordinator.Action)
  }


  @Dependency(\.continuousClock) var clock

   var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        case .view(let viewAction):
          return handleViewAction(&state, action: viewAction)

        case .scope(let scopeAction):
          return handleScopeAction(&state, action: scopeAction)
      }
    }
    .ifCaseLet(\.splash, action: \.scope.splash) {
      SplashReducer()
    }
    .ifCaseLet(\.home, action: \.scope.home) {
      HomeCoordinator()
    }
  }
}

extension AppReducer {
  func handleViewAction(
    _ state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .presentMain:
        state = .home(.init())
//      return .send(.scope(.mainTab(.scope(.movieCoordinator))))
      return .none
    }
  }


  func handleScopeAction(
    _ state: inout State,
    action: ScopeAction
  ) -> Effect<Action> {
    switch action {
      case .splash(.navigation(.presentMain)):
        return .run { send in
          try await clock.sleep(for: .seconds(1))
          await send(.view(.presentMain), animation: .easeOut)
        }


//      case .mainTab(.navigation(.backToLogin)):
//        return .run { send in
//          await send(.view(.presentAuth), animation: .easeIn)
//        }
      default: return .none

    }
  }
}
