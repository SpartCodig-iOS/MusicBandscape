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

  public init(
    family: PretendardFontFamily,
    size: CGFloat
  ) {
    self.family = family
    self.size = size
  }

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
#if canImport(UIKit)
 public extension UIFont {
   public static func pretendardFontFamily(family: PretendardFontFamily, size: CGFloat) -> UIFont {
    let fontName = "PretendardVariable-\(family)"
    return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
  }
}
#endif

 public extension Font {
   public static func pretendardFont(family: PretendardFontFamily, size: CGFloat) -> Font{
    let font = Font.custom("PretendardVariable-\(family)", size: size)
    return font
  }
}
