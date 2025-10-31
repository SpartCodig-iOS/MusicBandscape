//
//  SearchCoordinator.swift
//  Search
//
//  Created by Wonji Suh  on 10/28/25.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

import Core
import Detail


@Reducer
public struct SearchCoordinator {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    var routes: [Route<SearchScreen.State>]
    public init() {
      self.routes = [.root(.search(.init()), embedInNavigationView: true)]
    }
  }

  public enum Action: ViewAction {
    case router(IndexedRouterActionOf<SearchScreen>)
    case view(View)

  }

  public enum View {
    case backToRoot
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

extension SearchCoordinator {
  private func routerAction(
    state: inout State,
    action: IndexedRouterActionOf<SearchScreen>
  ) -> Effect<Action> {
    switch action {

      case .routeAction(id: _, action: .search(.navigation(.selectMusicItem(let item)))):
        state.routes.push(.detail(.init(musicItem: item)))
        return .none

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
        state.routes.goBackTo(\.search)
        return .none

    }
  }
}


extension SearchCoordinator {

  @Reducer(state: .equatable)
  public enum SearchScreen {
    case search(SearchReducer)
    case detail(DetailReducer)
  }
}

