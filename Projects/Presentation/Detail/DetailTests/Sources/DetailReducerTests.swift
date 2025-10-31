//
//  DetailReducerTests.swift
//  DetailTests
//
//  Created by Wonji Suh  on 10/25/25.
//

import Testing
import ComposableArchitecture
import Foundation
@testable import Detail
@testable import Core
@testable import DomainInterface       

extension Tag {
  @Tag static var unit: Self
  @Tag static var reducer: Self
}

private enum DummyError: Error { case fail }

private struct StubMusicDetailUseCase: MusicDetailUseCaseProtocol {
  let searchHandler: @Sendable (String) async throws -> [MusicItem]
  let fetchDetailHandler: @Sendable (Int) async throws -> MusicItem

  func searchMusic(searchQuery: String) async throws -> [MusicItem] {
    try await searchHandler(searchQuery)
  }

  func fetchTrackDetail(id: Int) async throws -> MusicItem {
    try await fetchDetailHandler(id)
  }
}

private extension MusicItem {
  static func stub(
    trackId: Int = 1,
    trackName: String = "Song",
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

@MainActor
@Suite("DetailReducerTests", .tags(.unit, .reducer))
struct DetailReducerTests {

  @Test("onAppear 성공: fetchTrackDetail 로 musicItem 업데이트 & 로딩 종료")
  func onAppear_success_updatesState() async throws {
    let before = MusicItem.stub(trackId: 777, trackName: "Before")
    let after  = MusicItem.stub(trackId: 777, trackName: "After")
    let clock = TestClock()

    let store = TestStore(
      initialState: DetailReducer.State(musicItem: before)
    ) {
      DetailReducer()
    } withDependencies: {
      $0.continuousClock = clock
      $0[MusicDetailUseCase.self] = StubMusicDetailUseCase(
        searchHandler: { _ in [] },
        fetchDetailHandler: { id in
          #expect(id == 777)
          return after
        }
      )
    }

    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.view(.onAppear)) { state in
      state.isLoading = true
    }

    await clock.advance(by: .seconds(2))
    await store.skipReceivedActions()

    #expect(store.state.musicItem?.trackId == 777)
    #expect(store.state.musicItem?.trackName == "After")
    #expect(store.state.isLoading == false)
  }

  @Test("onAppear 실패: 기존 item 유지 & 로딩 종료")
  func onAppear_failure_keepsItemAndStopsLoading() async throws {
    let before = MusicItem.stub(trackId: 999, trackName: "Keep")
    let clock = TestClock()

    let store = TestStore(
      initialState: DetailReducer.State(musicItem: before)
    ) {
      DetailReducer()
    } withDependencies: {
      $0.continuousClock = clock
      $0[MusicDetailUseCase.self] = StubMusicDetailUseCase(
        searchHandler: { _ in [] },
        fetchDetailHandler: { _ in throw DummyError.fail }
      )
    }

    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.view(.onAppear)) { state in
      state.isLoading = true
    }

    await clock.advance(by: .seconds(2))
    await store.skipReceivedActions()

    #expect(store.state.musicItem?.trackId == 999)
    #expect(store.state.musicItem?.trackName == "Keep")
    #expect(store.state.isLoading == false)
  }

  @Test("뒤로가기 액션: 상태 변화 없음")
  func backToHome_noStateChange() async throws {
    let store = TestStore(
      initialState: DetailReducer.State(musicItem: nil, isLoading: false)
    ) {
      DetailReducer()
    }

    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.navigation(.backToHome))
  }
}
