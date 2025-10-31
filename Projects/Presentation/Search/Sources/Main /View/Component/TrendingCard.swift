//
//  TrendingCard.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem
import Entity

public struct TrendingCard: View {
  private let item: TrendingItem

  public init(
    item: TrendingItem
  ) {
    self.item = item
  }

  public var body: some View {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(.neutralBlack)
        .overlay(
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(Color.black.opacity(0.06))
        )
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)

      VStack(alignment: .leading, spacing: 10) {
        Image(systemName: "chart.line.uptrend.xyaxis")
          .font(.pretendardFont(family: .semiBold, size: 18))
          .foregroundStyle(.green)

        Spacer(minLength: 0)

        Text(item.title)
          .font(.pretendardFont(family: .semiBold, size: 16))
          .foregroundStyle(.white)
      }
      .padding(16)
    }
    .frame(height: 92) 
    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
  }
}

