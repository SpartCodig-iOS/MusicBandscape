//
//  SearchBackground.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem

public struct SearchBackground: View {

  public init() {}

  public var body: some View {
    ZStack {
      LinearGradient(
        colors: [
          Color.backgroundDark,
          Color.neutralBlack,
          Color.nightRider,
        ],
        startPoint: .topTrailing,
        endPoint: .bottomLeading
      )


      RadialGradient(
        gradient: Gradient(colors: [
          Color.white.opacity(0.08),
          Color.clear
        ]),
        center: .top,
        startRadius: 20,
        endRadius: 420
      )
      .blendMode(.softLight)

      LinearGradient(
        colors: [
          Color.green.opacity(0.06),
          Color.clear
        ],
        startPoint: .top,
        endPoint: .center
      )
      .blur(radius: 40)
      .allowsHitTesting(false)
    }
    .ignoresSafeArea()
  }
}

