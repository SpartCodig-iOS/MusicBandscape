//
//  MockMusicDetailRepositoryTests.swift
//  Repository
//
//  Created by Wonji Suh  on 10/31/25.
//

import Testing
@testable import DataInterface
@testable import Model
@testable import Repository
import Foundation


@Suite("MockMusicDetailRepositoryTests Unit Tests", .tags(.unit, .mock, .repository))
struct MockMusicDetailRepositoryTests {

  @Test("상세 id 검색 성공시 결과가 올바 르게 반환")
  func testFetchMusicIdDetailSuccess() async throws {
    let mockTracks: [ITunesTrack] = [
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

    let repository = MockMusicDetailRepository()
    repository.setResult(.success(mockTracks))

    // when
    let result = try await repository.fetchDetailMusic(id: "100")

    // then
    #expect(result.count == 1)
    #expect(result.first?.trackId == 100)
    #expect(result.first?.artistName == "IU")
    #expect(result.first?.trackName == "Spring Love")
    #expect(result.first?.collectionCensoredName == "봄 사랑 벚꽃 말고 - Single")
  }

  @Test("검색  id 실패 시 에러를 던져야 함.")
  func testFetchIdDetailMusicFailure() async throws {
    // given
    let repository = MockMusicDetailRepository()
    repository.setResult(.failure(MockMusicDetailRepository.MockError.forced))

    // when / then
    await #expect(throws: MockMusicDetailRepository.MockError.forced) {
      try await repository.fetchDetailMusic(id: "fail")
    }
  }

  @Test("fetchDetailMusic 호출 시 검색어가 기록되어야 함")
  func testReceivedIdQuery() async throws {
    let repository = MockMusicDetailRepository(result: .success([]))
    _ = try await repository.fetchDetailMusic(id: "100")

    #expect(repository.receivedQueries == ["100"])
  }
}
