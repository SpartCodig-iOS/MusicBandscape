//
//  ITunesSearchResponseDTO.swift
//  Model
//
//  Created by Wonji Suh  on 10/24/25.
//

import Foundation

public struct ITunesSearchResponseDTO: Decodable {
  public let resultCount: Int
  public let results: [ITunesTrack]
}

// 트랙 항목
public struct ITunesTrack: Decodable {
  public let wrapperType: String?
  public let kind: String?

  public let artistId: Int?
  public let collectionId: Int?
  public let trackId: Int

  public let artistName: String
  public let collectionName: String?
  public let trackName: String

  public let previewUrl: URL?
  public let artworkUrl100: URL?

  public let releaseDate: String
  public let primaryGenreName: String
  public let collectionCensoredName: String

  enum CodingKeys: String, CodingKey {
    case wrapperType, kind, artistId, collectionId, trackId
    case artistName, collectionName, trackName, collectionCensoredName
    case previewUrl, artworkUrl100
    case releaseDate, primaryGenreName
  }

  public init(
    wrapperType: String?,
    kind: String?,
    artistId: Int?,
    collectionId: Int?,
    trackId: Int,
    artistName: String,
    collectionName: String?,
    trackName: String,
    previewUrl: URL?,
    artworkUrl100: URL?,
    releaseDate: String,
    primaryGenreName: String,
    collectionCensoredName: String
  ) {
    self.wrapperType = wrapperType
    self.kind = kind
    self.artistId = artistId
    self.collectionId = collectionId
    self.trackId = trackId
    self.artistName = artistName
    self.collectionName = collectionName
    self.trackName = trackName
    self.previewUrl = previewUrl
    self.artworkUrl100 = artworkUrl100
    self.releaseDate = releaseDate
    self.primaryGenreName = primaryGenreName
    self.collectionCensoredName = collectionCensoredName
  }
}


public extension ITunesTrack {
  static func mock(
    id: Int,
    artist: String = "IU",
    album: String = "Spring Album",
    name: String = "Spring Love",
    art: String = "https://example.com/art.jpg",
    preview: String = "https://example.com/prev.m4a",
    release: String = "2024-03-18T12:00:00Z",
    genre: String = "K-Pop",
    collectionCensoredName: String = "봄 사랑 벚꽃 말고 - Single"
  ) -> Self {
    .init(
      wrapperType: "track",
      kind: "song",
      artistId: 1,
      collectionId: 10,
      trackId: id,
      artistName: artist,
      collectionName: album,
      trackName: name,
      previewUrl: URL(string: preview),
      artworkUrl100: URL(string: art),
      releaseDate: release,
      primaryGenreName: genre,
      collectionCensoredName: collectionCensoredName
    )
  }
}
