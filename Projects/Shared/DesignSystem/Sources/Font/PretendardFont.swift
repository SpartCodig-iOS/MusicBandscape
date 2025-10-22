//
//  PretendardFont.swift
//  DesignSystem
//
//  Created by Wonji Suh  on 10/22/25.
//

import SwiftUI

public struct PretendardFont: ViewModifier {
  public let family: PretendardFontFamily
  public let size: CGFloat

  public func body(content: Content) -> some View {
    return content.font(.custom("PretendardVariable-\(family)", fixedSize: size))
  }
}

// extension View {
//  func pretendardFont(family: PretendardFontFamily, size: CGFloat) -> some View {
//    return self.modifier(PretendardFont(family: family, size: size))
//  }
//}
//
 public extension UIFont {
  static func pretendardFontFamily(family: PretendardFontFamily, size: CGFloat) -> UIFont {
    let fontName = "PretendardVariable-\(family)"
    return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
  }
}

 public extension Font {
  static func pretendardFont(family: PretendardFontFamily, size: CGFloat) -> Font{
    let font = Font.custom("PretendardVariable-\(family)", size: size)
    return font
  }
}
