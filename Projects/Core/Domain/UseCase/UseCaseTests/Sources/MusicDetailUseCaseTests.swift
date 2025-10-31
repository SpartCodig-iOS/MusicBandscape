//
//  MusicDetailUseCaseTests.swift
//  UseCase
//
//  Created by Wonji Suh  on 10/31/25.
//

import Testing
import Foundation
import DomainInterface
import DataInterface
import Entity
import Repository 
@testable import UseCase

@Suite("MusicDetailUseCaseTests", .tags(.unit, .useCase, .mock))
struct MusicDetailUseCaseTests {
  @Test("상세 검색 성공 시 DTO가 Domain으로 정상 변환")
  func testSearchDetailMusicSuccessMapsToDomain() async throws {
    // Given: Mock DTO 데이터 (가짜 iTunes 응답)
    let dto: [Model.ITunesTrack] = [
      .mock(id: 100, artist: "아이유", name: "봄노래"),
    ]
    let repo = MockMusicDetailRepository(result: .success(dto))
    let useCase = MusicDetailUseCase(repository: repo)

    // When: 유즈케이스 실행
    let items = try await useCase.fetchTrackDetail(id: 100)

    // Then: 결과 검증 (DTO → Domain 매핑)
    #expect(items.trackName == "봄노래", "첫 번째 곡 이름 매핑 확인")
    #expect(items.artist == "아이유", "아티스트 매핑 확인")
  }

  @Test("fetchTrackDetail 실패 시 에러처리")
  func testSearchDetailMusicFailureError() async {
    enum StubError: Error { case boom }
    let repo = MockMusicDetailRepository(result: .failure(StubError.boom))
    let useCase = MusicDetailUseCase(repository: repo)

    await #expect(throws: StubError.self) {
      _ = try await useCase.fetchTrackDetail(id: 0)
    }
  }
}
