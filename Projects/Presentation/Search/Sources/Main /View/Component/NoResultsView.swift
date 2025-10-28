//
//  NoResultsView.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem

struct NoResultsView: View {
  let searchQuery: String
  var onSuggestionTap: (String) -> Void = { _ in }

  private let suggestions = ["Top Hits", "K-Pop", "Jazz", "Podcasts"]

  var body: some View {
    VStack(spacing: 24) {
      Spacer()

      // 검색 아이콘
      Image(systemName: "magnifyingglass")
        .font(.system(size: 80, weight: .light))
        .foregroundStyle(.gray.opacity(0.6))

      VStack(spacing: 12) {
        // "No results found" 메시지
        Text("No results found")
          .font(.pretendardFont(family: .semiBold, size: 20))
          .foregroundStyle(.white)

        // 서브 메시지
        Text("Try different keywords or check spelling")
          .font(.pretendardFont(family: .regular, size: 16))
          .foregroundStyle(.gray)
          .multilineTextAlignment(.center)
      }

      VStack(alignment: .leading, spacing: 16) {
        // "Suggestions:" 텍스트
        HStack {
          Spacer()
          
          Text("Suggestions:")
            .font(.pretendardFont(family: .semiBold, size: 16))
            .foregroundStyle(.white)

          Spacer()
        }

        // 제안 태그들
        HStack(spacing: 12) {
          SuggestionTag(text: "Top Hits") {
            onSuggestionTap("Top Hits")
          }

          SuggestionTag(text: "K-Pop") {
            onSuggestionTap("K-Pop")
          }

          SuggestionTag(text: "Jazz") {
            onSuggestionTap("Jazz")
          }

          SuggestionTag(text: "Podcasts") {
            onSuggestionTap("Podcasts")
          }

          Spacer()
        }
      }
      .padding(.horizontal, 20)

      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct SuggestionTag: View {
  let text: String
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      Text(text)
        .font(.pretendardFont(family: .medium, size: 14))
        .foregroundStyle(.gray)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(.gray.opacity(0.2))
        )
    }
    .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  NoResultsView(searchQuery: "Top Hits")
    .background(Color.black)
}
