//
//  TrendingSection.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem
import Entity

struct TrendingSection: View {
  let items: [TrendingItem] = [
    TrendingItem(title: "Top Charts"),
    TrendingItem(title: "New Releases"),
    TrendingItem(title: "Podcasts"),
    TrendingItem(title: "Movies")
  ]

  // 필요 시 외부에서 주입해도 됨
  var onTap: (TrendingItem) -> Void = { _ in }

  // 카드 2열 그리드
  private let columns = [
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible(), spacing: 12)
  ]

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 8) {
        Image(systemName: "chart.line.uptrend.xyaxis")
          .font(.pretendardFont(family: .semiBold, size: 16))
          .foregroundStyle(.green)

        Text("Trending")
          .font(.pretendardFont(family: .semiBold, size: 18))
          .foregroundStyle(.white)
      }
      .padding(.horizontal, 4)

      Spacer()
        .frame(height: 5)

      LazyVGrid(columns: columns, spacing: 12) {
        ForEach(items) { item in
          TrendingCard(item: item)
            .onTapGesture { onTap(item) }
        }
      }
    }
    .padding(16)
    .background(Color.clear)
  }
}

