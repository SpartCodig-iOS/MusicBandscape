//
//  MusicDetailUseCaseProtocol.swift
//  DomainInterface
//
//  Created by Wonji Suh  on 10/31/25.
//

import Entity

public protocol MusicDetailUseCaseProtocol {
  func fetchTrackDetail(id: Int) async throws -> MusicItem
}

