//
//  SearchReducer.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//


import Foundation
import ComposableArchitecture
import Core
import Entity

@Reducer
public struct SearchReducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var searchText: String = ""
    public var recentSearches: [String] = []
    public var allSearchResults: [MusicItem] = []
    public var filteredSearchResults: [MusicItem] = []
    public var isSearching: Bool = false
    public var currentSearchQuery: String = ""
    public var selectedCategory: SearchCategory = .all

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

  //MARK: - ViewAction
  @CasePathable
  public enum View {
    case searchTextChanged(String)
    case searchSubmitted(String)
    case selectRecentSearch(String)
    case selectCategory(SearchCategory)
    case selectTrendingItem(String)
    case clearSearch
  }



  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case searchMedia(query: String, category: SearchCategory)
  }

  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction {
    case searchResponse(Result<[MusicItem], Error>)
  }

  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    case selectMusicItem(MusicItem)

  }

  private enum CancelID: Hashable {
    case searchMedia
  }

  @Dependency(MusicSearchUseCase.self) var musicSearchUseCase

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

extension SearchReducer {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
    case .searchTextChanged(let text):
      state.searchText = text

      // 검색어가 비어있으면 초기 상태로 복원
      if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        state.allSearchResults = []
        state.filteredSearchResults = []
        state.currentSearchQuery = ""
        state.selectedCategory = .all
      }
      return .none

    case .searchSubmitted(let searchText):
      let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
      if !trimmedText.isEmpty {
        // 기존 검색어가 있으면 제거하고 앞에 추가
        state.recentSearches.removeAll { $0 == trimmedText }
        state.recentSearches.insert(trimmedText, at: 0)

        // 최대 10개까지만 저장
        if state.recentSearches.count > 10 {
          state.recentSearches = Array(state.recentSearches.prefix(10))
        }

        // 검색 실행
        state.isSearching = true
        state.currentSearchQuery = trimmedText
        return .send(.async(.searchMedia(query: trimmedText, category: state.selectedCategory)))
      }
      return .none

    case .selectRecentSearch(let searchText):
      state.searchText = searchText
      return .send(.view(.searchSubmitted(searchText)))

    case .selectTrendingItem(let searchText):
      state.searchText = searchText
      return .send(.view(.searchSubmitted(searchText)))


    case .selectCategory(let category):
      state.selectedCategory = category

      // 현재 검색어가 있으면 새로운 카테고리로 다시 검색
      if !state.currentSearchQuery.isEmpty {
        state.isSearching = true
        return .send(.async(.searchMedia(query: state.currentSearchQuery, category: category)))
      } else {
        // 검색어가 없으면 기존 결과를 필터링만 (정렬은 이미 되어있음)
        state.filteredSearchResults = state.allSearchResults.filterByCategory(category)
        return .none
      }

    case .clearSearch:
      state.searchText = ""
      state.allSearchResults = []
      state.filteredSearchResults = []
      state.currentSearchQuery = ""
      state.selectedCategory = .all
      return .none
    }
  }




  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .searchMedia(let query, let category):
      return .run { send in
        let searchResult = await Result {
          // 카테고리에 따라 다른 media/entity 조합으로 검색
          switch category {
          case .all:
            // 모든 미디어 타입 검색
            try await musicSearchUseCase.searchMedia(query: query, media: "all", entity: "")
          case .music:
            // 음악만 검색
            try await musicSearchUseCase.searchMedia(query: query, media: "music", entity: "song")
          case .movies:
            // 영화 검색
            try await musicSearchUseCase.searchMedia(query: query, media: "movie", entity: "movie")
          case .podcast:
            // 팟캐스트 검색
            try await musicSearchUseCase.searchMedia(query: query, media: "podcast", entity: "podcast")
          case .etc:
            // 기타 미디어 검색
            try await musicSearchUseCase.searchMedia(query: query, media: "all", entity: "")
          }
        }

        await send(.inner(.searchResponse(searchResult)))
      }
      .cancellable(id: CancelID.searchMedia, cancelInFlight: true)
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
      case .selectMusicItem(let musicItem):
        state.$detailMusicItem.withLock { $0 = musicItem }
        return .none
    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
    case .searchResponse(let result):
      state.isSearching = false

      switch result {
      case .success(let results):
        let sortedResults = results.sortedByLatest()
        state.allSearchResults = sortedResults
        state.filteredSearchResults = sortedResults.filterByCategory(state.selectedCategory)
      case .failure(let error):
        print("🔥 검색 에러: \(error.localizedDescription)")
        state.allSearchResults = []
        state.filteredSearchResults = []
      }

      return .none
    }
  }
}

