//
//  MusicSearchAPI.swift
//  API
//
//  Created by Wonji Suh  on 10/23/25.
//

import Foundation

public enum MusicSearchAPI: String {
  case search
  case detail

  public var description: String {
    switch self {
      case .search:
        return ""

      case .detail:
        return ""
    }
  }
}
