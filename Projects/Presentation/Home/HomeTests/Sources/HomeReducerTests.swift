//
//  HomeReducerTests.swift
//  HomeTests
//
//  Created by Wonji Suh  on 10/30/25.
//

import IdentifiedCollections
import Testing
import ComposableArchitecture
import DomainInterface

@testable import Home
@testable import Core

import Foundation


extension Tag {
  @Tag static var mock: Self
  @Tag static var unit: Self
  @Tag static var reducer: Self
}


private enum DummyError: Error { case fail }

private struct StubMusicSearchUseCase: MusicSearchUseCaseProtocol {
  let searchHandler: @Sendable (String) async throws -> [MusicItem]
  let fetchDetailHandler: @Sendable (Int) async throws -> Entity.MusicItem
  let searchMediaHandler: @Sendable (String, String, String) async throws -> [Entity.MusicItem]
  let getCategoryCountHandler: ([Entity.MusicItem], Entity.SearchCategory) -> Int

  init(
    searchHandler: @escaping @Sendable (String) async throws -> [MusicItem],
    fetchDetailHandler: @escaping @Sendable (Int) async throws -> Entity.MusicItem,
    searchMediaHandler: @escaping @Sendable (String, String, String) async throws -> [Entity.MusicItem] = { _, _, _ in [] },
    getCategoryCountHandler: @escaping ([Entity.MusicItem], Entity.SearchCategory) -> Int = { results, category in
      switch category {
      case .all:
        return results.count
      case .music:
        return results.musicCount
      case .movies:
        return results.movieCount
      case .podcast:
        return results.podcastCount
      case .etc:
        return results.etcCount
      }
    }
  ) {
    self.searchHandler = searchHandler
    self.fetchDetailHandler = fetchDetailHandler
    self.searchMediaHandler = searchMediaHandler
    self.getCategoryCountHandler = getCategoryCountHandler
  }

  func searchMusic(searchQuery: String) async throws -> [MusicItem] {
    try await searchHandler(searchQuery)
  }

  func searchMedia(query: String, media: String, entity: String) async throws -> [Entity.MusicItem] {
    try await searchMediaHandler(query, media, entity)
  }

  func getCategoryCount(from results: [Entity.MusicItem], category: Entity.SearchCategory) -> Int {
    getCategoryCountHandler(results, category)
  }

  func fetchTrackDetail(id: Int) async throws -> Entity.MusicItem {
    try await fetchDetailHandler(id)
  }
}

extension MusicItem {
  static func stub(
    id: UUID = UUID(),
    trackId: Int = 1,
    trackName: String = "Song",
    album: String = "Album",
    artist: String = "Artist",
    artworkURL: URL = URL(string: "https://example.com/100.png")!,
    releaseDate: String? = "2024-01-02T03:04:05Z",
    genre: String = "Pop"
  ) -> Self {
    .init(
      trackId: trackId,
      trackName: trackName,
      album: album,
      artist: artist,
      artworkURL: artworkURL,
      releaseDate: releaseDate ?? "",
      genre: genre
    )
  }
}

extension Entity.MusicItem {
  static func stub(
    trackId: Int = 1,
    trackName: String = "detail",
    album: String = "Album",
    artist: String = "Artist",
    artworkURL: URL = URL(string: "https://example.com/100.png")!,
    releaseDate: String = "2024-01-02T03:04:05Z",
    genre: String = "Pop"
  ) -> Self {
    .init(
      trackId: trackId,
      trackName: trackName,
      album: album,
      artist: artist,
      artworkURL: artworkURL,
      releaseDate: releaseDate,
      genre: genre
    )
  }
}

private enum Fixture {
  static let popular: [MusicItem] = [
    .stub(trackId: 101, trackName: "P-Old", releaseDate: "2023-01-01T00:00:00Z"),
    .stub(trackId: 102, trackName: "P-New", releaseDate: "2024-12-31T00:00:00Z"),
  ]
  static let spring: [MusicItem] = [
    .stub(trackId: 201, trackName: "S-1", releaseDate: "2025-03-01T09:00:00Z"),
    .stub(trackId: 202, trackName: "S-2", releaseDate: "2025-04-01T09:00:00Z"),
  ]
  static let summer: [MusicItem] = [
    .stub(trackId: 301, trackName: "SU-1", releaseDate: "2025-07-01T09:00:00Z"),
  ]
  static let autumn: [MusicItem] = [
    .stub(trackId: 401, trackName: "A-1", releaseDate: "2025-10-01T09:00:00Z"),
  ]
  static let winter: [MusicItem] = [
    .stub(trackId: 501, trackName: "W-1", releaseDate: "2025-12-01T09:00:00Z"),
  ]

  static func all(by query: String) -> [MusicItem] {
    switch query.lowercased() {
    case MusicSeason.popular.term.lowercased(): return popular
    case MusicSeason.spring.term.lowercased():  return spring
    case MusicSeason.summer.term.lowercased():  return summer
    case MusicSeason.autumn.term.lowercased():  return autumn
    case MusicSeason.winter.term.lowercased():  return winter
    default: return []
    }
  }
}

@MainActor
@Suite("HomeReducerTests", .tags(.unit, .reducer))
struct HomeReducerTests {

  @Test("onAppear 시 모든 시즌 로드 성공")
  func onAppear_fetchAll_success() async throws {
    let store = TestStore(initialState: HomeReducer.State()) {
      HomeReducer()
    } withDependencies: {
      $0[MusicSearchUseCase.self] = StubMusicSearchUseCase(
        searchHandler: { query in Fixture.all(by: query) },
        fetchDetailHandler: { _ in .stub() }
      )
      $0.mainQueue = .immediate
    }

    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.view(.onAppear))
    await store.skipReceivedActions()

    #expect(store.state.popularMusicModel.count == Fixture.popular.count)
    #expect(store.state.springMusicModel.count  == Fixture.spring.count)
    #expect(store.state.summerMusicModel.count  == Fixture.summer.count)
    #expect(store.state.autumnMusicModel.count  == Fixture.autumn.count)
    #expect(store.state.winterMusicModel.count  == Fixture.winter.count)

    let isSortedDesc: (IdentifiedArrayOf<MusicItem>) -> Bool = { arr in
      let dates = arr.compactMap { $0.releaseDateValue }
      return dates == dates.sorted(by: >)
    }
    #expect(isSortedDesc(store.state.popularMusicModel))
    #expect(isSortedDesc(store.state.springMusicModel))
    #expect(isSortedDesc(store.state.summerMusicModel))
    #expect(isSortedDesc(store.state.autumnMusicModel))
    #expect(isSortedDesc(store.state.winterMusicModel))
    #expect(store.state.errorMessage?.isEmpty ?? true)
  }

  @Test("특정 시즌 실패 시 errorMessage 설정")
  func fetchMusic_failure_setsErrorMessage() async throws {
    let store = TestStore(initialState: HomeReducer.State()) {
      HomeReducer()
    } withDependencies: {
      $0[MusicSearchUseCase.self] = StubMusicSearchUseCase(
        searchHandler: { query in
          if query.lowercased() == MusicSeason.spring.term.lowercased() {
            throw DummyError.fail
          }
          return Fixture.all(by: query)
        },
        fetchDetailHandler: { _ in .stub() }
      )
      $0.mainQueue = .immediate
    }

    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.async(.fetchMusic(.spring)))
    await store.skipReceivedActions()

    #expect(store.state.errorMessage?.isEmpty == false)
  }

  @Test("카드 탭 시 detailMusicItem 공유 상태 설정")
  func navigation_cardTap_setsSharedDetail() async throws {
    let store = TestStore(initialState: HomeReducer.State()) {
      HomeReducer()
    } withDependencies: {
      $0[MusicSearchUseCase.self] = StubMusicSearchUseCase(
        searchHandler: { _ in Fixture.popular },
        fetchDetailHandler: { _ in .stub() }
      )
      $0.mainQueue = .immediate
    }

    let picked = Fixture.popular[0]

    await store.send(.navigation(.musicCardTapped(item: picked))) { state in
      state.$detailMusicItem.withLock { $0 = picked }
    }

    #expect(store.state.detailMusicItem?.trackId == picked.trackId)
  }

  @Test("searchMedia 호출 시 지정한 핸들러와 파라미터 사용")
  func searchMedia_usesInjectedHandler() async throws {
    let expectedItems: [Entity.MusicItem] = [
      .stub(trackId: 1, trackName: "Song-1"),
      .stub(trackId: 2, trackName: "Song-2")
    ]

    var captured: (String, String, String)?

    let useCase = StubMusicSearchUseCase(
      searchHandler: { _ in Fixture.popular },
      fetchDetailHandler: { _ in .stub() },
      searchMediaHandler: { query, media, entity in
        captured = (query, media, entity)
        return expectedItems
      }
    )

    let result = try await useCase.searchMedia(query: "K-Pop", media: "music", entity: "song")

    #expect(result == expectedItems)
    #expect(captured?.0 == "K-Pop")
    #expect(captured?.1 == "music")
    #expect(captured?.2 == "song")
  }

  @Test("getCategoryCount 카테고리별 건수 반환")
  func getCategoryCount_returnsCategorySpecificCounts() {
    let sampleResults: [Entity.MusicItem] = [
      .init(
        trackId: 1,
        trackName: "Music",
        album: "Album",
        artist: "Artist",
        artworkURL: URL(string: "https://example.com/1.png")!,
        releaseDate: "2024-01-01T00:00:00Z",
        genre: "Pop",
        mediaType: .music
      ),
      .init(
        trackId: 2,
        trackName: "Movie",
        album: "Movie Album",
        artist: "Director",
        artworkURL: URL(string: "https://example.com/2.png")!,
        releaseDate: "2024-02-01T00:00:00Z",
        genre: "Drama",
        mediaType: .movie
      ),
      .init(
        trackId: 3,
        trackName: "Podcast",
        album: "Podcast Album",
        artist: "Host",
        artworkURL: URL(string: "https://example.com/3.png")!,
        releaseDate: "2024-03-01T00:00:00Z",
        genre: "Talk",
        mediaType: .podcast
      ),
      .init(
        trackId: 4,
        trackName: "Other",
        album: "Other Album",
        artist: "Creator",
        artworkURL: URL(string: "https://example.com/4.png")!,
        releaseDate: "2024-04-01T00:00:00Z",
        genre: "Misc",
        mediaType: .other
      ),
      .init(
        trackId: 5,
        trackName: "Music-2",
        album: "Second Album",
        artist: "Artist",
        artworkURL: URL(string: "https://example.com/5.png")!,
        releaseDate: "2024-05-01T00:00:00Z",
        genre: "Pop",
        mediaType: .music
      )
    ]

    let useCase = StubMusicSearchUseCase(
      searchHandler: { _ in Fixture.popular },
      fetchDetailHandler: { _ in .stub() }
    )

    #expect(useCase.getCategoryCount(from: sampleResults, category: .all) == 5)
    #expect(useCase.getCategoryCount(from: sampleResults, category: .music) == 2)
    #expect(useCase.getCategoryCount(from: sampleResults, category: .movies) == 1)
    #expect(useCase.getCategoryCount(from: sampleResults, category: .podcast) == 1)
    #expect(useCase.getCategoryCount(from: sampleResults, category: .etc) == 1)
  }
}
