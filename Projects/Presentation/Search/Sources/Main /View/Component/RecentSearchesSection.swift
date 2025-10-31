//
//  RecentSearchesSection.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem

struct RecentSearchesSection: View {
  let recentSearches: [String]
  var onTapSearch: (String) -> Void = { _ in }

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 8) {
        Image(systemName: "clock")
          .font(.pretendardFont(family: .semiBold, size: 16))
          .foregroundStyle(.gray)

        Text("Recent Searches")
          .font(.pretendardFont(family: .semiBold, size: 18))
          .foregroundStyle(.white)

        Spacer()
      }
      .padding(.horizontal, 20)

      if !recentSearches.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 12) {
            ForEach(recentSearches, id: \.self) { search in
              SearchTag(text: search) {
                onTapSearch(search)
              }
            }
          }
          .padding(.horizontal, 20)
        }
      } else {
        HStack {
          Text("No recent searches")
            .font(.pretendardFont(family: .regular, size: 14))
            .foregroundStyle(.gray)

          Spacer()
        }
        .padding(.horizontal, 20)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct SearchTag: View {
  let text: String
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      Text(text)
        .font(.pretendardFont(family: .medium, size: 14))
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.gray.opacity(0.3))
        )
    }
    .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  RecentSearchesSection(recentSearches: ["Top Hits", "K-Pop", "Jazz", "Marvel"])
    .background(Color.black)
}