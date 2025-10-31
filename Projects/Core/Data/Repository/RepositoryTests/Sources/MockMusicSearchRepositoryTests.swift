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
  @Tag static var moyaStub: Self
}

@Suite("MusicSearchRepository Unit Tests", .tags(.unit, .mock, .repository))
struct MockMusicSearchRepositoryTests {

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
}
