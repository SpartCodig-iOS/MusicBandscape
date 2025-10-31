//
//  MusicDetailRepositoryProtocol.swift
//  DataInterface
//
//  Created by Wonji Suh  on 10/31/25.
//

import Foundation
import Model

public protocol MusicDetailRepositoryProtocol : Sendable {
  func fetchDetailMusic(id: String) async throws -> [ITunesTrack]
}
