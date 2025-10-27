//
//  BaseAPI.swift
//  API
//
//  Created by Wonji Suh  on 10/23/25.
//

import Foundation

public enum BaseAPI : String {
  case base


  public var description: String {
    switch self {
    case .base:
      return "https://\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? "")"

    }
  }
}

