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

  @Test("searchMusic 검색 성공 시 DTO가 Domain으로 정상 변환")
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
    #expect(items.count == 2, "결과 개수가 올바르다 ")
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

  @Test("getCategoryCount - 각 카테고리별 정확한 개수 반환")
  func testGetCategoryCount() {
    // Given: 각 미디어 타입별로 다른 개수의 아이템들
    let musicItems = [
      MusicItem.detailMusicItem, // music
      MusicItem(trackId: 2, trackName: "Movie Title", album: "Movie Album", artist: "Director",
                artworkURL: URL(string: "https://example.com/movie.jpg")!, previewURL: nil,
                releaseDate: "2024-01-01T00:00:00Z", aboutAlbumInfo: "Movie Info",
                genre: "Action", mediaType: .movie),
      MusicItem(trackId: 3, trackName: "Podcast Episode", album: "Podcast Series", artist: "Host",
                artworkURL: URL(string: "https://example.com/podcast.jpg")!, previewURL: nil,
                releaseDate: "2024-01-01T00:00:00Z", aboutAlbumInfo: "Episode Info",
                genre: "Technology", mediaType: .podcast),
      MusicItem(trackId: 4, trackName: "Other Content", album: "Other Album", artist: "Other Artist",
                artworkURL: URL(string: "https://example.com/other.jpg")!, previewURL: nil,
                releaseDate: "2024-01-01T00:00:00Z", aboutAlbumInfo: "Other Info",
                genre: "Unknown", mediaType: .other),
      MusicItem(trackId: 5, trackName: "Another Music", album: "Music Album", artist: "Singer",
                artworkURL: URL(string: "https://example.com/music2.jpg")!, previewURL: nil,
                releaseDate: "2024-01-01T00:00:00Z", aboutAlbumInfo: "Music Info",
                genre: "Pop", mediaType: .music)
    ]

    let repo = MockMusicSearchRepository()
    let useCase = MusicSearchUseCase(repository: repo)

    // Then: 각 카테고리별 정확한 개수 확인
    #expect(useCase.getCategoryCount(from: musicItems, category: .all) == 5, "전체 개수가 5개")
    #expect(useCase.getCategoryCount(from: musicItems, category: .music) == 2, "음악 2개")
    #expect(useCase.getCategoryCount(from: musicItems, category: .movies) == 1, "영화 1개")
    #expect(useCase.getCategoryCount(from: musicItems, category: .podcast) == 1, "팟캐스트 1개")
    #expect(useCase.getCategoryCount(from: musicItems, category: .etc) == 1, "기타 1개")
  }

  @Test("getCategoryCount - 빈 배열에서 0 반환")
  func testGetCategoryCountWithEmptyArray() {
    let repo = MockMusicSearchRepository()
    let useCase = MusicSearchUseCase(repository: repo)
    let emptyItems: [MusicItem] = []

    // Then: 모든 카테고리에서 0 반환
    #expect(useCase.getCategoryCount(from: emptyItems, category: .all) == 0)
    #expect(useCase.getCategoryCount(from: emptyItems, category: .music) == 0)
    #expect(useCase.getCategoryCount(from: emptyItems, category: .movies) == 0)
    #expect(useCase.getCategoryCount(from: emptyItems, category: .podcast) == 0)
    #expect(useCase.getCategoryCount(from: emptyItems, category: .etc) == 0)
  }

  @Test("searchMedia 성공 시 올바른 파라미터 전달 및 Domain 변환")
  func testSearchMediaSuccessWithCorrectParameters() async throws {
    // Given: Mock DTO 데이터
    let dto: [Model.ITunesTrack] = [
      .mock(id: 300, artist: "BTS", name: "Dynamite"),
      .mock(id: 400, artist: "BLACKPINK", name: "How You Like That")
    ]
    let repo = MockMusicSearchRepository(result: .success(dto))
    let useCase = MusicSearchUseCase(repository: repo)

    // When: searchMedia 실행
    let items = try await useCase.searchMedia(query: "K-Pop", media: "music", entity: "song")

    // Then: 올바른 파라미터가 전달되었는지 확인
    #expect(repo.receivedQueries.contains("K-Pop|music|song"), "올바른 파라미터 전달 확인")

    // Domain 변환 확인
    #expect(items.count == 2, "결과 개수가 2개")
    #expect(items[0].trackName == "Dynamite", "첫 번째 곡 이름 확인")
    #expect(items[0].artist == "BTS", "첫 번째 아티스트 확인")
    #expect(items[1].trackName == "How You Like That", "두 번째 곡 이름 확인")
    #expect(items[1].artist == "BLACKPINK", "두 번째 아티스트 확인")
  }

  @Test("searchMedia 실패 시 에러 전파")
  func testSearchMediaFailurePropagatesError() async {
    enum SearchError: Error { case networkFailure }
    let repo = MockMusicSearchRepository(result: .failure(SearchError.networkFailure))
    let useCase = MusicSearchUseCase(repository: repo)

    await #expect(throws: SearchError.self) {
      _ = try await useCase.searchMedia(query: "fail", media: "music", entity: "song")
    }
  }

  @Test("searchMedia 다양한 미디어 타입 테스트")
  func testSearchMediaWithDifferentMediaTypes() async throws {
    // Given
    let dto: [Model.ITunesTrack] = [.mock(id: 500, artist: "Test Artist", name: "Test Content")]
    let repo = MockMusicSearchRepository(result: .success(dto))
    let useCase = MusicSearchUseCase(repository: repo)

    // When: 다양한 미디어 타입으로 검색
    _ = try await useCase.searchMedia(query: "test", media: "movie", entity: "movie")
    _ = try await useCase.searchMedia(query: "test", media: "podcast", entity: "podcast")
    _ = try await useCase.searchMedia(query: "test", media: "music", entity: "musicTrack")

    // Then: 각각 다른 파라미터가 전달되었는지 확인
    #expect(repo.receivedQueries.contains("test|movie|movie"), "영화 검색 파라미터 확인")
    #expect(repo.receivedQueries.contains("test|podcast|podcast"), "팟캐스트 검색 파라미터 확인")
    #expect(repo.receivedQueries.contains("test|music|musicTrack"), "음악 검색 파라미터 확인")
  }
}
