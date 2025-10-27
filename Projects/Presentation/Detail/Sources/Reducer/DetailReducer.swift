//
//  DetailReducer.swift
//  Detail
//
//  Created by Wonji Suh  on 10/27/25.
//


import Foundation
import ComposableArchitecture

import Core

@Reducer
public struct DetailReducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    @Shared var musicItem: MusicItem?
    public init(
      musicItem: MusicItem?
    ) {
      self._musicItem = Shared(wrappedValue: musicItem, .inMemory("MusicItem"))
    }
  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)

  }

  //MARK: - ViewAction
  @CasePathable
  public enum View {

  }



  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {

  }

  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
  }

  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {


  }


  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

        case .async(let asyncAction):
          return handleAsyncAction(state: &state, action: asyncAction)

        case .inner(let innerAction):
          return handleInnerAction(state: &state, action: innerAction)

        case .navigation(let navigationAction):
          return handleNavigationAction(state: &state, action: navigationAction)
      }
    }
  }
}

extension DetailReducer {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {

    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {

    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {

    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {

    }
  }
}

