//
//  Extension+ITunesTrack.swift
//  Entity
//
//  Created by Wonji Suh  on 10/24/25.
//


import Foundation

import Model

public extension ITunesTrack {
  func toDomain() -> MusicItem? {
    guard let artwork = artworkUrl100 else {
      return nil
    }

    return MusicItem(
      trackId: trackId,
      trackName: trackName,
      album: collectionName ?? "Unknown Album",
      artist: artistName,
      artworkURL: artwork,
      previewURL: previewUrl,
      releaseDate: releaseDate,
      aboutAlbumInfo: collectionCensoredName,
      genre: primaryGenreName
    )
  }
}

public extension Array where Element == ITunesTrack {
  func toDomain() -> [MusicItem] {
    compactMap { $0.toDomain() }
  }
}
