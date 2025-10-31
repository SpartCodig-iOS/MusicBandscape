//
//  HomeCoordinator.swift
//  Home
//
//  Created by Wonji Suh  on 10/27/25.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

import Core
import Detail


@Reducer
public struct HomeCoordinator {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    var routes: [Route<HomeScreen.State>]
    public init() {
      self.routes = [.root(.home(.init()), embedInNavigationView: true)]
    }
  }

  public enum Action: ViewAction {
    case router(IndexedRouterActionOf<HomeScreen>)
    case view(View)

  }

  public enum View {
    case backToRoot
    case switchTapBar
  }



  private enum CancelID: Hashable {
    case screen
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

        case .router(let routeAction):
          return routerAction(state: &state, action: routeAction)

        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

      }
    }
    .forEachRoute(\.routes, action: \.router, cancellationId: CancelID.screen)
  }
}

extension HomeCoordinator {
  private func routerAction(
    state: inout State,
    action: IndexedRouterActionOf<HomeScreen>
  ) -> Effect<Action> {
    switch action {

      case .routeAction(id: _, action: .home(.navigation(.musicCardTapped(let item)))):
        state.routes.push(.detail(.init(musicItem: item)))
        return .none

      case .routeAction(id: _, action: .home(.navigation(.tapSearch))):
        return .send(.view(.switchTapBar))

      case .routeAction(id: _, action: .detail(.navigation(.backToHome))):
//        state.routes.goBackToRoot()
        return .send(.view(.backToRoot))

      default:
        return .none

    }
  }

  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .backToRoot:
        state.routes.goBackTo(\.home)
        return .none

      case .switchTapBar:
        return .none
    }
  }
}


extension HomeCoordinator {

  @Reducer(state: .equatable)
  public enum HomeScreen {
    case home(HomeReducer)
    case detail(DetailReducer)
  }
}

