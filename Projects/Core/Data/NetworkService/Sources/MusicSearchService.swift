//
//  MusicSearchService.swift
//  Service
//
//  Created by Wonji Suh  on 10/24/25.
//

import Foundation
import Foundations
import API
import Moya

public enum MusicSearchService {
  case searchMusic(query: String, media: String, entity: String)
  case detailMusic(id: String)
}


extension MusicSearchService: BaseTargetType {
  public typealias Domain = MusicScapeDomain

  public var domain: API.MusicScapeDomain {
    switch self {
      case .searchMusic:
        return .searchMusic
      case .detailMusic:
        return .searchDetailMusic
    }
  }

  public var urlPath: String {
    switch self {
      case .searchMusic:
        return MusicSearchAPI.search.description

      case .detailMusic:
        return MusicSearchAPI.detail.description
    }
  }
  
  public var error: [Int : Foundations.NetworkError]? {
    return nil
  }
  
  public var parameters: [String : Any]? {
    switch self {
      case .searchMusic(
        let query,
        let media,
        let entity
      ):
        let parameters: [String: Any] = [
          "term": query,
          "country": "KR",
          "media": media,
          "entity": entity
        ]
      return parameters

      case .detailMusic(let id):
        let parameters: [String: Any] = [
          "id": id,
          "country": "KR",
        ]
        return parameters


    }
  }
  
  public var method: Moya.Method {
    switch self {
      case .searchMusic, .detailMusic:
        return .get
    }
  }
}
