//
//  MainTab.swift
//  RootTab
//
//  Created by Wonji Suh  on 10/28/25.
//

import Foundation

public enum MainTab: String, CaseIterable {
  case home, search

  public var tabBarTiltle: String {
    switch self {
      case .home:
        return "홈"

      case .search:
        return "검색"
    }
  }
}
