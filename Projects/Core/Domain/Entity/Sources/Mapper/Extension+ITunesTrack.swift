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

    // wrapperType과 kind를 사용해서 MediaType 결정
    let mediaType: MediaType = {
      guard let kind = kind else { return .other }

      switch kind.lowercased() {
      case "song":
        return .music
      case "feature-movie", "movie":
        return .movie
      case "podcast":
        return .podcast
      default:
        return .other
      }
    }()

    return MusicItem(
      trackId: trackId,
      trackName: trackName,
      album: collectionName ?? "Unknown Album",
      artist: artistName,
      artworkURL: artwork,
      previewURL: previewUrl,
      releaseDate: releaseDate,
      aboutAlbumInfo: collectionCensoredName,
      genre: primaryGenreName,
      mediaType: mediaType
    )
  }
}


public extension Array where Element == ITunesTrack {
  func toDomain() -> [MusicItem] {
    compactMap { $0.toDomain() }
  }
}
