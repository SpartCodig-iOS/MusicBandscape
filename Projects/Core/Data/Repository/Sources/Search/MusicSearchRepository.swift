//
//  MusicSearchRepository.swift
//  Repository
//
//  Created by Wonji Suh  on 10/24/25.
//

import Foundation
import NetworkService
import DataInterface

import AsyncMoya

public final class MusicSearchRepository: MusicSearchRepositoryProtocol {
  @MainActor private let provider = MoyaProvider<MusicSearchService>(plugins: [MoyaLoggingPlugin()])

  nonisolated public init() {}

  public func fetchMusic(search: String) async throws -> [Model.ITunesTrack] {
    let data = try await provider.request(
      .searchMusic(
        query: search,
        media: "'music'",
        entity: "song"
      ),
      decodeTo: ITunesSearchResponseDTO.self
    )
    return data.results
  }

  public func searchMedia(
    query: String,
    media: String,
    entity: String
  ) async throws -> [Model.ITunesTrack] {
    let data = try await provider.request(
      .searchMusic(
        query: query,
        media: media,
        entity: entity
      ),
      decodeTo: ITunesSearchResponseDTO.self
    )
    return data.results
  }
}
