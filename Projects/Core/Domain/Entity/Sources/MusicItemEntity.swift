//
//  MusicItemEntity.swift
//  Entity
//
//  Created by Wonji Suh  on 10/23/25.
//

import Foundation



public struct MusicItem: Identifiable, Equatable {
  public var id = UUID()
  public let trackId: Int
  public let trackName: String
  public let album: String
  public let artist: String
  public let artworkURL: URL
  public let previewURL: URL?
  public let releaseDate: String
  public let aboutAlbumInfo: String
  public let genre: String
  public let mediaType: MediaType

  public init(
    trackId: Int,
    trackName: String,
    album: String,
    artist: String,
    artworkURL: URL,
    previewURL: URL? = nil,
    releaseDate: String,
    aboutAlbumInfo: String = "",
    genre: String,
    mediaType: MediaType = .music
  ) {
    self.trackId = trackId
    self.trackName = trackName
    self.album = album
    self.artist = artist
    self.artworkURL = artworkURL
    self.previewURL = previewURL
    self.releaseDate = releaseDate
    self.aboutAlbumInfo = aboutAlbumInfo
    self.genre = genre
    self.mediaType = mediaType
  }
}

public extension MusicItem {
  private static let iso8601Formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()

  var releaseDateValue: Date? {
    MusicItem.iso8601Formatter.date(from: releaseDate)
  }

  var highResolutionArtworkURL: URL {
    let targetSizes = ["1080x1080", "1200x1200", "600x600", "400x400", "300x300", "200x200"]
    let original = artworkURL.absoluteString

    for size in targetSizes {
      if let range = original.range(of: "100x100") {
        let upgraded = original.replacingCharacters(in: range, with: size)
        if let url = URL(string: upgraded) {
          return url
        }
      }
    }

    return artworkURL
  }

  static var detailMusicItem: MusicItem {
    return  MusicItem(
      trackId: 1838638363,
      trackName: "20s",
      album: "CODA",
      artist: "유다빈밴드",
      artworkURL: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/56/77/98/567798ec-369a-0cfd-3b0d-5fd55b62d3e3/887928030889.jpg/100x100bb.jpg")!,
      previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview211/v4/21/0e/1e/210e1e3f-2b94-eca8-8a9b-19403bd2ef71/mzaf_5723681619052556286.plus.aac.p.m4a"),
      releaseDate: "2025-09-15T12:00:00Z",
      aboutAlbumInfo: "CODA",
      genre: "록",
      mediaType: .music
    )
  }
}


// MARK: - Array Extension for Filtering
public extension Array where Element == MusicItem {
  func filterByCategory(_ category: SearchCategory) -> [MusicItem] {
    switch category {
    case .all:
      return self
    case .music:
      return filter { $0.mediaType == .music }
    case .movies:
      return filter { $0.mediaType == .movie }
    case .podcast:
      return filter { $0.mediaType == .podcast }
    case .etc:
      return filter { $0.mediaType == .other }
    }
  }

  var musicCount: Int { filter { $0.mediaType == .music }.count }
  var movieCount: Int { filter { $0.mediaType == .movie }.count }
  var podcastCount: Int { filter { $0.mediaType == .podcast }.count }
  var etcCount: Int { filter { $0.mediaType == .other }.count }

  /// 최신 순으로 정렬 (releaseDate 기준 내림차순)
  func sortedByLatest() -> [MusicItem] {
    return sorted { lhs, rhs in
      guard let lhsDate = lhs.releaseDateValue,
            let rhsDate = rhs.releaseDateValue else {
        // 날짜가 없는 경우 맨 뒤로
        return lhs.releaseDateValue != nil
      }
      return lhsDate > rhsDate // 최신이 먼저 오도록
    }
  }
}
