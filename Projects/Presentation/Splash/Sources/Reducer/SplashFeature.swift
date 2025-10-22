//
//  SplashReducer.swift
//  Splash
//
//  Created by Wonji Suh  on 10/22/25.
//


import Foundation
import SwiftUI

import ComposableArchitecture


@Reducer
public struct SplashReducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var logoOpacity: CGFloat = 0
    var logoScale: CGFloat = 0.85
    var pulse = false
    var textOpacity: CGFloat = 0
    var textOffset: CGFloat = 20
    var subtitleOpacity: CGFloat = 0
    var footerOpacity: CGFloat = 0
    public init() {}
  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case inner(InnerAction)
    case navigation(NavigationAction)

  }

  //MARK: - ViewAction
  @CasePathable
  public enum View {
    case onAppear
    case startAnimation
  }


  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
    case startAnimationSequence
    case updateLogo(opacity: CGFloat, scale: CGFloat)
    case updateText(opacity: CGFloat, offset: CGFloat)
    case updateSubtitle(opacity: CGFloat)
    case updateFooter(opacity: CGFloat)
  }

  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    case presentMain

  }


  private enum CancelID { case animation }

  @Dependency(\.continuousClock) var clock

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

        case .inner(let innerAction):
          return handleInnerAction(state: &state, action: innerAction)

        case .navigation(let navigationAction):
          return handleNavigationAction(state: &state, action: navigationAction)
      }
    }
  }
}

extension SplashReducer {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .onAppear:
        return .send(.view(.startAnimation))

      case .startAnimation:
        return .send(.inner(.startAnimationSequence))
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
      case .presentMain:
        return .none
    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      case .startAnimationSequence:
        state.pulse = true
        return .run { send in
          await send(.inner(.updateLogo(opacity: 1, scale: 1)), animation: .easeInOut(duration: 1.2))

          try await clock.sleep(for: .milliseconds(300))
          await send(.inner(.updateText(opacity: 1, offset: 0)),animation: .easeInOut(duration: 1.2))

          try await clock.sleep(for: .milliseconds(200))
          await send(.inner(.updateSubtitle(opacity: 1)),animation: .easeInOut(duration: 1.2))

          try await clock.sleep(for: .milliseconds(300))
          await send(.inner(.updateFooter(opacity: 0.6)),animation: .easeInOut(duration: 1.2))

          try await clock.sleep(for: .seconds(2))
          await send(.navigation(.presentMain))
        }
        .cancellable(id: CancelID.animation)

      case let .updateLogo(opacity, scale):
        state.logoOpacity = opacity
        state.logoScale = scale
        return .none

      case let .updateText(opacity, offset):
        state.textOpacity = opacity
        state.textOffset = offset
        return .none

      case let .updateSubtitle(opacity):
        state.subtitleOpacity = opacity
        return .none

      case let .updateFooter(opacity):
        state.footerOpacity = opacity
        return .none


    }
  }
}

