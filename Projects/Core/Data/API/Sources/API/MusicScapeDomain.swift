//
//  MusicScapeDomain.swift
//  API
//
//  Created by Wonji Suh  on 10/23/25.
//

import Foundation
import Networking


public enum MusicScapeDomain {
  case searchMusic
  case searchDetailMusic
}

extension MusicScapeDomain: DomainType {
  public var baseURLString: String {
    return BaseAPI.base.description
  }

  public var url: String {
    switch self {
      case .searchMusic:
        return "search"

      case .searchDetailMusic:
        return "lookup"
    }
  }
}
