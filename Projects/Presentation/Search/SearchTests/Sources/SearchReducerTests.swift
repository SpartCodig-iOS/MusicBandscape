//
//  SearchReducerTests.swift
//  Search
//
//  Created by Wonji Suh  on 10/31/25.
//

import Testing
import Foundation
import ComposableArchitecture

@testable import Search   // ← SearchReducer 모듈명에 맞게 조정해줘
@testable import Core
@testable import Entity
import DomainInterface    // MusicSearchUseCase 키 주입

// MARK: - Test Tags (선택)
extension Tag {
  @Tag static var unit: Self
  @Tag static var reducer: Self
}

// MARK: - Stub UseCase

private enum DummyError: Error { case fail }

private struct StubMusicSearchUseCase: MusicSearchUseCaseProtocol {
  var searchMusicHandler: @Sendable (String) async throws -> [Core.MusicItem] = { _ in [] }
  var fetchDetailHandler: @Sendable (Int) async throws -> Entity.MusicItem = { _ in .stub() }
  var searchMediaHandler: @Sendable (String, String, String) async throws -> [Entity.MusicItem] = { _,_,_ in [] }
  var getCategoryCountHandler: ([Entity.MusicItem], Entity.SearchCategory) -> Int = { results, category in
    switch category {
    case .all:    return results.count
    case .music:  return results.filter { $0.mediaType == .music   }.count
    case .movies: return results.filter { $0.mediaType == .movie   }.count
    case .podcast:return results.filter { $0.mediaType == .podcast }.count
    case .etc:    return results.filter { $0.mediaType == .other   }.count
    }
  }

  func searchMusic(searchQuery: String) async throws -> [Core.MusicItem] {
    try await searchMusicHandler(searchQuery)
  }

  func fetchTrackDetail(id: Int) async throws -> Entity.MusicItem {
    try await fetchDetailHandler(id)
  }

  func searchMedia(query: String, media: String, entity: String) async throws -> [Entity.MusicItem] {
    try await searchMediaHandler(query, media, entity)
  }

  func getCategoryCount(from results: [Entity.MusicItem], category: Entity.SearchCategory) -> Int {
    getCategoryCountHandler(results, category)
  }
}

// MARK: - Fixtures

private extension Entity.MusicItem {
  static func make(
    trackId: Int,
    name: String,
    mediaType: Entity.MediaType
  ) -> Self {
    .init(
      trackId: trackId,
      trackName: name,
      album: "Album \(trackId)",
      artist: "Artist \(trackId)",
      artworkURL: URL(string: "https://example.com/\(trackId).png")!,
      releaseDate: "2024-01-01T00:00:00Z",
      genre: "Pop",
      mediaType: mediaType
    )
  }

  static func stub(
    trackId: Int = 1,
    trackName: String = "detail",
    album: String = "Album",
    artist: String = "Artist",
    artworkURL: URL = URL(string: "https://example.com/100.png")!,
    releaseDate: String = "2024-01-02T03:04:05Z",
    genre: String = "Pop",
    mediaType: Entity.MediaType = .music
  ) -> Self {
    .init(
      trackId: trackId,
      trackName: trackName,
      album: album,
      artist: artist,
      artworkURL: artworkURL,
      releaseDate: releaseDate,
      genre: genre,
      mediaType: mediaType
    )
  }
}

// MARK: - Suites

@MainActor
@Suite("SearchReducerTests", .tags(.unit, .reducer))
struct SearchReducerTests {

  @Test("searchTextChanged에 빈 문자열 넣으면 상태 초기화")
  func searchTextChanged_empty_resets() async throws {
    var initial = SearchReducer.State()
    initial.searchText = "abc"
    initial.allSearchResults = [.stub(trackId: 1)]
    initial.filteredSearchResults = [.stub(trackId: 1)]
    initial.currentSearchQuery = "abc"
    initial.selectedCategory = .music
    initial.musicCount = 1
    initial.movieCount = 2
    initial.podcastCount = 3
    initial.etcCount = 4

    let store = TestStore(initialState: initial) {
      SearchReducer()
    }

    await store.send(.view(.searchTextChanged(""))) { state in
      state.searchText = ""
      state.allSearchResults = []
      state.filteredSearchResults = []
      state.currentSearchQuery = ""
      state.selectedCategory = .all
      state.musicCount = 0
      state.movieCount = 0
      state.podcastCount = 0
      state.etcCount = 0
    }
  }

  @Test("searchSubmitted 성공: 최근검색어 갱신 + 결과/필터 세팅 + 로딩 Off")
  func searchSubmitted_success_updatesRecentAndResults() async throws {
    let samples: [Entity.MusicItem] = [
      .make(trackId: 1, name: "M-1", mediaType: .music),
      .make(trackId: 2, name: "MV-1", mediaType: .movie),
      .make(trackId: 3, name: "P-1", mediaType: .podcast),
    ]

    var captured: (query: String, media: String, entity: String)?
    let useCase = StubMusicSearchUseCase(
      searchMediaHandler: { q, m, e in
        captured = (q, m, e)
        return samples
      }
    )

    let store = TestStore(initialState: SearchReducer.State()) {
      SearchReducer()
    } withDependencies: {
      $0[MusicSearchUseCase.self] = useCase
      $0.mainQueue = .immediate
    }

    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.view(.searchSubmitted("IU"))) { state in
      state.isSearching = true
      state.currentSearchQuery = "IU"
      // recentSearches는 inner 처리 후 최종 확인
    }

    // 비동기 액션 소비
    await store.skipReceivedActions()

    // 최종 상태 검증
    #expect(store.state.isSearching == false)
    #expect(store.state.currentSearchQuery == "IU")
    #expect(store.state.recentSearches.first == "IU")
    #expect(!store.state.allSearchResults.isEmpty)
    #expect(!store.state.filteredSearchResults.isEmpty)
    #expect(store.state.musicCount == 1)
    #expect(store.state.movieCount == 1)
    #expect(store.state.podcastCount == 1)
    #expect(store.state.etcCount == 0)

    // 파라미터 검증: 기본은 카테고리 .all 이므로 media: "all", entity: ""
    #expect(captured?.query == "IU")
    #expect(captured?.media == "all")
    #expect(captured?.entity == "")
  }

  @Test("searchSubmitted: 동일 검색어 재입력 시 최근검색어 중복 제거 후 맨 앞에 위치")
  func searchSubmitted_dedup_recentQueries() async throws {
    let useCase = StubMusicSearchUseCase(
      searchMediaHandler: { _,_,_ in [ .make(trackId: 1, name: "M", mediaType: .music) ] }
    )

    var initial = SearchReducer.State()
    initial.recentSearches = ["IU", "NewJeans"]

    let store = TestStore(initialState: initial) {
      SearchReducer()
    } withDependencies: {
      $0[MusicSearchUseCase.self] = useCase
      $0.mainQueue = .immediate
    }

    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.view(.searchSubmitted("IU"))) { state in
      state.isSearching = true
      state.currentSearchQuery = "IU"
      // dedup은 inner 후 최종 검사
    }
    await store.skipReceivedActions()

    #expect(store.state.recentSearches.first == "IU")
    #expect(store.state.recentSearches.dropFirst().contains("IU") == false)
  }

  @Test("selectRecentSearch는 입력값으로 searchSubmitted 다시 트리거")
  func selectRecentSearch_triggersSubmit() async throws {
    var submitted = ""
    let useCase = StubMusicSearchUseCase(
      searchMediaHandler: { q,_,_ in
        submitted = q
        return [ .make(trackId: 1, name: "M", mediaType: .music) ]
      }
    )

    let store = TestStore(initialState: SearchReducer.State()) {
      SearchReducer()
    } withDependencies: {
      $0[MusicSearchUseCase.self] = useCase
      $0.mainQueue = .immediate
    }

    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.view(.selectRecentSearch("coldplay"))) { state in
      state.searchText = "coldplay"
    }
    await store.skipReceivedActions()

    #expect(submitted == "coldplay")
    #expect(store.state.currentSearchQuery == "coldplay")
    #expect(store.state.recentSearches.first == "coldplay")
    #expect(store.state.musicCount == 1)
    #expect(store.state.movieCount == 0)
    #expect(store.state.podcastCount == 0)
    #expect(store.state.etcCount == 0)
  }

  @Test("selectCategory: currentSearchQuery가 있으면 새 검색 요청")
  func selectCategory_withQuery_triggersNewSearch() async throws {
    var initial = SearchReducer.State()
    initial.currentSearchQuery = "beatles"   // 이미 검색어 존재
    initial.selectedCategory = .all

    var captured: (media: String, entity: String)?
    let useCase = StubMusicSearchUseCase(
      searchMediaHandler: { q, m, e in
        captured = (m, e)
        return [ .make(trackId: 1, name: q, mediaType: .music) ]
      }
    )

    let store = TestStore(initialState: initial) {
      SearchReducer()
    } withDependencies: {
      $0[MusicSearchUseCase.self] = useCase
      $0.mainQueue = .immediate
    }

    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.view(.selectCategory(.music))) { state in
      state.selectedCategory = .music
      state.isSearching = true
    }
    await store.skipReceivedActions()

    #expect(store.state.isSearching == false)
    #expect(captured?.media == "music")
    #expect(captured?.entity == "song")
  }

  @Test("selectCategory: currentSearchQuery가 없으면 필터만 적용")
  func selectCategory_withoutQuery_filtersOnly() async throws {
    var initial = SearchReducer.State()
    initial.currentSearchQuery = "" 
    initial.selectedCategory = .all

    initial.allSearchResults = [
      .init(trackId: 1, trackName: "m1", album: "a", artist: "ar",
            artworkURL: URL(string: "https://e.com/1.png")!,
            releaseDate: "2024-01-01T00:00:00Z", genre: "Pop", mediaType: .music),
      .init(trackId: 2, trackName: "m2", album: "a", artist: "ar",
            artworkURL: URL(string: "https://e.com/2.png")!,
            releaseDate: "2024-01-02T00:00:00Z", genre: "Pop", mediaType: .music),
      .init(trackId: 3, trackName: "mv1", album: "a", artist: "ar",
            artworkURL: URL(string: "https://e.com/3.png")!,
            releaseDate: "2024-01-03T00:00:00Z", genre: "Drama", mediaType: .movie),
      .init(trackId: 4, trackName: "etc1", album: "a", artist: "ar",
            artworkURL: URL(string: "https://e.com/4.png")!,
            releaseDate: "2024-01-04T00:00:00Z", genre: "Misc", mediaType: .other)
    ]

    let store = TestStore(initialState: initial) {
      SearchReducer()
    }

    await store.send(.view(.selectCategory(.music))) { state in
      state.selectedCategory = .music
      state.filteredSearchResults = state.allSearchResults.filterByCategory(.music)
    }

    #expect(store.state.filteredSearchResults.count == 2)
  }

  @Test("clearSearch는 상태 전체 리셋")
  func clearSearch_resetsAll() async throws {
    var initial = SearchReducer.State()
    initial.searchText = "zzz"
    initial.currentSearchQuery = "hello"
    initial.selectedCategory = .music
    initial.allSearchResults = [.stub(trackId: 1)]
    initial.filteredSearchResults = [.stub(trackId: 1)]
    initial.musicCount = 1
    initial.movieCount = 1
    initial.podcastCount = 1
    initial.etcCount = 1

    let store = TestStore(initialState: initial) {
      SearchReducer()
    }

    await store.send(.view(.clearSearch)) { state in
      state.searchText = ""
      state.allSearchResults = []
      state.filteredSearchResults = []
      state.currentSearchQuery = ""
      state.selectedCategory = .all
      state.musicCount = 0
      state.movieCount = 0
      state.podcastCount = 0
      state.etcCount = 0
    }
  }

  @Test("selectMusicItem은 공유 상태에 디테일 저장")
  func navigation_selectMusicItem_setsSharedDetail() async throws {
    let picked = Entity.MusicItem.stub(trackId: 77, trackName: "Pick", mediaType: .music)

    let store = TestStore(initialState: SearchReducer.State()) {
      SearchReducer()
    }

    await store.send(.navigation(.selectMusicItem(picked))) { state in
      state.$detailMusicItem.withLock { $0 = picked }
    }

    #expect(store.state.detailMusicItem?.trackId == 77)
  }

  @Test("searchSubmitted 실패 시 결과 초기화 및 isSearching false")
  func searchSubmitted_failure_clearsAndStops() async throws {
    let useCase = StubMusicSearchUseCase(
      searchMediaHandler: { _,_,_ in throw DummyError.fail }
    )

    let store = TestStore(initialState: SearchReducer.State()) {
      SearchReducer()
    } withDependencies: {
      $0[MusicSearchUseCase.self] = useCase
      $0.mainQueue = .immediate
    }

    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.view(.searchSubmitted("error"))) { state in
      state.isSearching = true
      state.currentSearchQuery = "error"
    }
    await store.skipReceivedActions()

    #expect(store.state.isSearching == false)
    #expect(store.state.allSearchResults.isEmpty)
    #expect(store.state.filteredSearchResults.isEmpty)
    #expect(store.state.musicCount == 0)
    #expect(store.state.movieCount == 0)
    #expect(store.state.podcastCount == 0)
    #expect(store.state.etcCount == 0)
  }
}
