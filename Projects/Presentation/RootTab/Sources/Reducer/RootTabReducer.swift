//
//  RootTabReducer.swift
//  RootTab
//
//  Created by Wonji Suh  on 10/28/25.
//


import Foundation
import ComposableArchitecture

import Home
import Search

@Reducer
public struct RootTabReducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    var selectedTab: MainTab = .home
    var homeCoordinator = HomeCoordinator.State()
    var searchCoordinator = SearchCoordinator.State()

    public init() {}

  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
   case scope(ScopeAction)

  }

  //MARK: - ViewAction
  @CasePathable
  public enum View {
    case selectTab(MainTab)
  }

  @CasePathable
  public enum ScopeAction {
    case homeCoordinator(HomeCoordinator.Action)
    case searchCoordinator(SearchCoordinator.Action)
  }



  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

        case .scope(let scopeAction):
          return handleScopeAction(state: &state, action: scopeAction)


      }
    }
    Scope(state: \.homeCoordinator, action: \.scope.homeCoordinator) {
      HomeCoordinator()
    }
    Scope(state: \.searchCoordinator, action: \.scope.searchCoordinator) {
      SearchCoordinator()
    }
  }
}

extension RootTabReducer {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .selectTab(let tab):
        state.selectedTab = tab
        return .none

    }
  }


  private func handleScopeAction(
    state: inout State,
    action: ScopeAction
  ) -> Effect<Action> {
    switch action {

      case .homeCoordinator(.view(.switchTapBar)):
        state.selectedTab = .search
        return .none

      default:
        return .none
    }
  }
}

