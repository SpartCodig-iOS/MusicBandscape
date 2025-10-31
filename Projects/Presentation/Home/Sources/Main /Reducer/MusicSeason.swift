//
//  MusicSeason.swift
//  Home
//
//  Created by Wonji Suh  on 10/27/25.
//

import Foundation

public enum MusicSeason: CaseIterable, Equatable, Sendable, Identifiable {
  case popular, spring, summer, autumn, winter

  public var id: Self { self }

  public var term: String {
    switch self {
    case .popular: return "유다빈밴드"
    case .spring:  return "봄"
    case .summer:  return "여름"
    case .autumn:  return "가을"
    case .winter:  return "겨울"
    }
  }

  public var title: String {
    switch self {
      case .spring: return "봄 스타일 음악"
      case .summer: return "여름 스타일 음악"
      case .autumn: return "가을 스타일 음악"
      case .winter: return "겨울 스타일 음악"
      case .popular:
        return ""
    }
  }
}
