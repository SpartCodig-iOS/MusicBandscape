//
//  TrendingItem.swift
//  Entity
//
//  Created by Wonji Suh  on 10/28/25.
//

import Foundation

public struct TrendingItem: Identifiable, Hashable {
  public let id = UUID()
  public let title: String

  public init(title: String) {
    self.title = title
  }
}
