//
//  MusicDetailRepository.swift
//  Repository
//
//  Created by Wonji Suh  on 10/31/25.
//


import Foundation
import Service
import DataInterface

import AsyncMoya

public final class MusicDetailRepository: MusicDetailRepositoryProtocol {
  @MainActor private let provider = MoyaProvider<MusicSearchService>(plugins: [MoyaLoggingPlugin()])

  nonisolated public init() {}

  public func fetchDetailMusic(id: String) async throws -> [Model.ITunesTrack] {
    let data = try await provider.request(.detailMusic(id: id), decodeTo: ITunesSearchResponseDTO.self)
    return data.results
  }
}
