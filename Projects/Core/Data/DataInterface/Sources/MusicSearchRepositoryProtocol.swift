//
//  MusicSearchRepositoryProtocol.swift
//  DataInterface
//
//  Created by Wonji Suh  on 10/24/25.
//

import Foundation
import Model

public protocol MusicSearchRepositoryProtocol: Sendable {
  func fetchMusic(search: String) async throws -> [ITunesTrack]
  func searchMedia(query: String, media: String, entity: String) async throws -> [ITunesTrack]
}
