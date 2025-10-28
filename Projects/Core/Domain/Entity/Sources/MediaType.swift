//
//  MediaType.swift
//  Entity
//
//  Created by Wonji Suh  on 10/28/25.
//

import Foundation

public enum MediaType: String, Codable, CaseIterable {
  case music = "music"
  case movie = "movie"
  case podcast = "podcast"
  case other = "other"
}
