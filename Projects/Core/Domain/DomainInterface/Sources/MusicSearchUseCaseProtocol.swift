//
//  MusicSearchUseCaseProtocol.swift
//  DomainInterface
//
//  Created by Wonji Suh  on 10/24/25.
//

import Entity

public protocol MusicSearchUseCaseProtocol {
  func searchMusic(searchQuery: String) async throws -> [MusicItem]
  func fetchTrackDetail(id: Int) async throws -> MusicItem
}

