//
//  MusicSearchRepository.swift
//  Repository
//
//  Created by Wonji Suh  on 10/24/25.
//

import Foundation
import Service
import DataInterface

import AsyncMoya

public final class MusicSearchRepository: MusicSearchRepositoryProtocol {
  @MainActor private let provider = MoyaProvider<MusicSearchService>(plugins: [MoyaLoggingPlugin()])

  nonisolated public init() {}

  public func fetchMusic(search: String) async throws -> [Model.ITunesTrack] {
    let data = try await provider.requestAsync(.searchMusic(query: search), decodeTo: ITunesSearchResponseDTO.self)
    return data.results
  }

  public func fetchDetailMusic(id: String) async throws -> [Model.ITunesTrack] {
    let data = try await provider.requestAsync(.detailMusic(id: id), decodeTo: ITunesSearchResponseDTO.self)
    return data.results
  }
}
