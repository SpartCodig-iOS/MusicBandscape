//
//  TrendingCard.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem
import Entity

struct TrendingCard: View {
  let item: TrendingItem

  var body: some View {
    ZStack(alignment: .topLeading) {
      // 카드 배경
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(.neutralBlack)
        .overlay( // 살짝의 윤곽감
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
    .frame(height: 92) // 스크린샷 느낌에 맞춰 높이 고정
    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
  }
}

