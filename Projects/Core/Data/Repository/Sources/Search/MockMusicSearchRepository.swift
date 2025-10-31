//
//  MockMusicSearchRepository.swift
//  Repository
//
//  Created by Wonji Suh  on 10/24/25.
//

@preconcurrency import DataInterface

public final class MockMusicSearchRepository: MusicSearchRepositoryProtocol, @unchecked Sendable {

  public enum MockError: Error { case forced }

  public var result: Result<[Model.ITunesTrack], Error>
  public private(set) var receivedQueries: [String] = []

  public init(result: Result<[Model.ITunesTrack], Error> = .success([])) {
    self.result = result
  }

  public func setResult(_ newResult: Result<[Model.ITunesTrack], Error>) {
    self.result = newResult
  }

  public func fetchMusic(search: String) async throws -> [Model.ITunesTrack] {
    self.receivedQueries.append(search)           // 호출 파라미터 검증용
    return try result.get()
  }
}
