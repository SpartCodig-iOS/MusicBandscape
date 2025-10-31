//
//  MockMusicSearchRepositoryTests.swift
//  Repository
//
//  Created by Wonji Suh  on 10/25/25.
//

import Testing
@testable import DataInterface
@testable import Model
@testable import Repository
import Foundation

extension Tag {
  @Tag static var mock: Self
  @Tag static var unit: Self
  @Tag static var repository: Self
}

@Suite("MusicSearchRepository Unit Tests", .tags(.unit, .mock, .repository))
struct MusicSearchRepositoryTests {

  // 🎯 1) 성공 케이스 테스트
  @Test("검색 성공 시 결과가 올바르게 반환 ")
  func testFetchMusicSuccess() async throws {
    // given
    let mockTracks: [Model.ITunesTrack] = [
      .init(
        wrapperType: "track",
        kind: "song",
        artistId: 1,
        collectionId: 10,
        trackId: 100,
        artistName: "IU",
        collectionName: "Spring Album",
        trackName: "Spring Love",
        previewUrl: URL(string: "https://example.com/prev.m4a"),
        artworkUrl100: URL(string: "https://example.com/art.jpg"),
        releaseDate: "2024-03-18T12:00:00Z",
        primaryGenreName: "K-Pop",
        collectionCensoredName: "봄 사랑 벚꽃 말고 - Single"
      )
    ]

    let repository = MockMusicSearchRepository()
    repository.setResult(.success(mockTracks))

    // when
    let result = try await repository.fetchMusic(search: "봄")

    // then
    #expect(result.count == 1)
    #expect(result.first?.artistName == "IU")
    #expect(result.first?.trackName == "Spring Love")
    #expect(result.first?.collectionCensoredName == "봄 사랑 벚꽃 말고 - Single")
  }

  // 🎯 2) 실패 케이스 테스트
  @Test("검색 실패 시 에러를 던져야 함.")
  func testFetchMusicFailure() async throws {
    // given
    let repository = MockMusicSearchRepository()
    repository.setResult(.failure(MockMusicSearchRepository.MockError.forced))

    // when / then
    await #expect(throws: MockMusicSearchRepository.MockError.forced) {
      try await repository.fetchMusic(search: "fail")
    }
  }

  @Test("fetchMusic 호출 시 검색어가 기록되어야 함")
  func testReceivedQuery() async throws {
    let repository = MockMusicSearchRepository(result: .success([]))
    _ = try await repository.fetchMusic(search: "유다빈밴드")

    #expect(repository.receivedQueries == ["유다빈밴드"])
  }

  // 🎯 searchMusic 메서드 테스트 (with filters)
  @Test("searchMusic 성공 시 결과가 올바르게 반환 (with filters)")
  func testSearchMusicWithFiltersSuccess() async throws {
    // given
    let mockTracks: [Model.ITunesTrack] = [
      .init(
        wrapperType: "track",
        kind: "song",
        artistId: 1,
        collectionId: 10,
        trackId: 100,
        artistName: "IU",
        collectionName: "Spring Album",
        trackName: "Spring Love",
        previewUrl: URL(string: "https://example.com/prev.m4a"),
        artworkUrl100: URL(string: "https://example.com/art.jpg"),
        releaseDate: "2024-03-18T12:00:00Z",
        primaryGenreName: "K-Pop",
        collectionCensoredName: "봄 사랑 벚꽃 말고 - Single"
      )
    ]

    let repository = MockMusicSearchRepository()
    repository.setResult(.success(mockTracks))

    // when
    let result = try await repository.searchMedia(
      query: "IU",
      media: "music",
      entity: "song"
    )

    // then
    #expect(result.count == 1)
    #expect(result.first?.artistName == "IU")
    #expect(result.first?.trackName == "Spring Love")
    #expect(result.first?.collectionCensoredName == "봄 사랑 벚꽃 말고 - Single")
  }

  @Test("searchMusic 실패 시 에러를 던져야 함 (with filters)")
  func testSearchMusicWithFiltersFailure() async throws {
    // given
    let repository = MockMusicSearchRepository()
    repository.setResult(.failure(MockMusicSearchRepository.MockError.forced))

    // when / then
    await #expect(throws: MockMusicSearchRepository.MockError.forced) {
      try await repository.searchMedia(
        query: "fail",
        media: "music",
        entity: "song"
      )
    }
  }

  @Test("searchMusic 호출 시 모든 파라미터가 기록되어야 함 (with filters)")
  func testSearchMusicWithFiltersReceivedParameters() async throws {
    let repository = MockMusicSearchRepository(result: .success([]))
    _ = try await repository.searchMedia(
      query: "IU",
      media: "music",
      entity: "song"
    )

    #expect(repository.receivedQueries == ["IU|music|song"])
  }

  @Test("searchMusic 다양한 media, entity 조합 테스트 (with filters)")
  func testSearchMusicWithFiltersDifferentParameters() async throws {
    let repository = MockMusicSearchRepository(result: .success([]))

    // 첫 번째 호출
    _ = try await repository.searchMedia(
      query: "Taylor Swift",
      media: "music",
      entity: "album"
    )

    // 두 번째 호출
    _ = try await repository.searchMedia(
      query: "Avengers",
      media: "movie",
      entity: "movieArtist"
    )

    #expect(repository.receivedQueries == [
      "Taylor Swift|music|album",
      "Avengers|movie|movieArtist"
    ])
  }
}
