//
//  MusicSearchUseCaseTests.swift
//  UseCase
//
//  Created by Wonji Suh  on 10/24/25.
//

import Testing
import Foundation
import DomainInterface
import DataInterface
import Entity
import Repository // (필요 시)
@testable import UseCase

extension Tag {
  @Tag static var mock: Self
  @Tag static var unit: Self
  @Tag static var useCase: Self
}


@Suite("MusicSearchUseCase", .tags(.unit, .useCase, .mock))
struct MusicSearchUseCaseTests {

  @Test("ssearchMusic  검색 성공 시 DTO가 Domain으로 정상 변환")
  func testSearchMusicSuccessMapsToDomain() async throws {
    // Given: Mock DTO 데이터 (가짜 iTunes 응답)
    let dto: [Model.ITunesTrack] = [
      .mock(id: 100, artist: "아이유", name: "봄노래"),
      .mock(id: 200, artist: "10CM", name: "여름밤")
    ]
    let repo = MockMusicSearchRepository(result: .success(dto))
    let useCase = MusicSearchUseCase(repository: repo)

    // When: 유즈케이스 실행
    let items = try await useCase.searchMusic(searchQuery: "유다빈밴드")

    // Then: 결과 검증 (DTO → Domain 매핑)
    #expect(items.count == 2, "결과 개수가 올바르다 ✅")
    #expect(items[0].trackName == "봄노래", "첫 번째 곡 이름 매핑 확인")
    #expect(items[0].artist == "아이유", "아티스트 매핑 확인")
    #expect(items[1].trackName == "여름밤", "두 번째 곡 이름 매핑 확인")
    #expect(items[1].artist == "10CM", "아티스트 매핑 확인")
  }

  @Test("searchMusic 실패 시 에러처리")
  func testSearchMusicFailurePropagatesError() async {
    enum StubError: Error { case boom }
    let repo = MockMusicSearchRepository(result: .failure(StubError.boom))
    let useCase = MusicSearchUseCase(repository: repo)

    await #expect(throws: StubError.self) {
      _ = try await useCase.searchMusic(searchQuery: "fail-me")
    }
  }

  @Test("상세 검색 성공 시 DTO가 Domain으로 정상 변환")
  func testSearchDetailMusicSuccessMapsToDomain() async throws {
    // Given: Mock DTO 데이터 (가짜 iTunes 응답)
    let dto: [Model.ITunesTrack] = [
      .mock(id: 100, artist: "아이유", name: "봄노래"),
    ]
    let repo = MockMusicSearchRepository(result: .success(dto))
    let useCase = MusicSearchUseCase(repository: repo)

    // When: 유즈케이스 실행
    let items = try await useCase.fetchTrackDetail(id: 100)

    // Then: 결과 검증 (DTO → Domain 매핑)
    #expect(items.trackName == "봄노래", "첫 번째 곡 이름 매핑 확인")
    #expect(items.artist == "아이유", "아티스트 매핑 확인")
  }

  @Test("searchMusic 실패 시 에러처리")
  func testSearchDetailMusicFailureError() async {
    enum StubError: Error { case boom }
    let repo = MockMusicSearchRepository(result: .failure(StubError.boom))
    let useCase = MusicSearchUseCase(repository: repo)

    await #expect(throws: StubError.self) {
      _ = try await useCase.fetchTrackDetail(id: 0)
    }
  }
}
