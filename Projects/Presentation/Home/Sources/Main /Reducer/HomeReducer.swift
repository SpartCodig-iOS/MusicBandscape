import Foundation
import ComposableArchitecture
import Core
import DomainInterface

@Reducer
public struct HomeReducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var popularMusicModel: [MusicItem] = []
    var springMusicModel: [MusicItem] = []
    var summerMusicModel: [MusicItem] = []
    var autumnMusicModel: [MusicItem] = []
    var winterMusicModel: [MusicItem] = []
    var errorMessage: String? = ""
    @Shared(.inMemory("MusicItem")) var detailMusicItem : MusicItem? = nil
    public init() {}
  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)
  }

  @CasePathable
  public enum View {
    case onAppear
  }

  public enum AsyncAction: Equatable {
    case fetchAll
    case fetchMusic(MusicSeason)
  }

  public enum InnerAction {
    case fetchMusicResponse(MusicSeason, Result<[MusicItem], Error>)
  }

  public enum NavigationAction: Equatable {
    case musicCardTapped(item: MusicItem)
  }

  @Dependency(MusicSearchUseCase.self) var musicSearchUseCase
  @Dependency(\.continuousClock) var clock
  @Dependency(\.mainQueue) var mainQueue

  private struct CancelID: Hashable { let category: MusicSeason }
  private struct HomeCancel: Hashable {}

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
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

extension HomeReducer.State {
  public func items(for season: MusicSeason) -> [MusicItem] {
    switch season {
      case .popular: return popularMusicModel
      case .spring:  return springMusicModel
      case .summer:  return summerMusicModel
      case .autumn:  return autumnMusicModel
      case .winter:  return winterMusicModel
    }
  }
}

extension HomeReducer {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(.async(.fetchAll))

    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .fetchAll:
      return .merge(
        MusicSeason.allCases.map { .send(.async(.fetchMusic($0))) }
      )
      .debounce(id: HomeCancel(), for: 0.1, scheduler: mainQueue)

    case .fetchMusic(let category):
      return .run { send in
        let musicSearchResult = await Result {
          try await musicSearchUseCase.searchMusic(searchQuery: category.term)
        }

        switch musicSearchResult {
          case .success(let musicSearchData):
            await send(.inner(.fetchMusicResponse(category, .success(musicSearchData))))
          case .failure(let error):
            await send(.inner(.fetchMusicResponse(category, .failure(error))))
        }
      }
      .cancellable(id: CancelID(category: category), cancelInFlight: true)
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
      case .musicCardTapped(let item):
        state.$detailMusicItem.withLock { $0 = item }
        return .none
    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
    case let .fetchMusicResponse(category, result):
      switch result {
      case .success(let items):
        let sortedItems = items.sorted {
          let lhsDate = $0.releaseDateValue ?? .distantPast
          let rhsDate = $1.releaseDateValue ?? .distantPast
          return lhsDate > rhsDate
        }

        switch category {
        case .popular: state.popularMusicModel = sortedItems
        case .spring:  state.springMusicModel  = sortedItems
        case .summer:  state.summerMusicModel  = sortedItems
        case .autumn:  state.autumnMusicModel  = sortedItems
        case .winter:  state.winterMusicModel  = sortedItems
        }
      case .failure(let error):
        state.errorMessage = error.localizedDescription
      }
      return .none
    }
  }
}
