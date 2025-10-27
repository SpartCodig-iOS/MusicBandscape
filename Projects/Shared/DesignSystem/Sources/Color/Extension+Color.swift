//
//  Extension+Color.swift
//  DesignSystem
//
//  Created by Wonji Suh  on 10/22/25.
//

import SwiftUI

public extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    guard hex.count == 6 || hex.count == 8 else {
      self.init(red: 0, green: 0, blue: 0)
      return
    }
    
    let scanner = Scanner(string: hex)
    
    var rgb: UInt64 = 0
    
    guard scanner.scanHexInt64(&rgb) else {
      self.init(red: 0, green: 0, blue: 0)
      return
    }
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}
