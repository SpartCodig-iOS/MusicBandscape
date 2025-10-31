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
    self.receivedQueries.append(search)
    return try result.get()
  }

  public func searchMedia(
    query: String,
    media: String,
    entity: String
  ) async throws -> [ITunesTrack] {
    self.receivedQueries.append("\(query)|\(media)|\(entity)")
    return try result.get()
  }
}
