//
//  SearchCategoryFilter.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem
import Entity

struct SearchCategoryFilter: View {
  let selectedCategory: SearchCategory
  let musicCount: Int
  let movieCount: Int
  let podcastCount: Int
  let etcCount: Int
  var onCategorySelect: (SearchCategory) -> Void = { _ in }

  var body: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
          ForEach(SearchCategory.allCases, id: \.self) { category in
            CategoryTab(
              category: category,
              isSelected: selectedCategory == category,
              count: countForCategory(category),
              onTap: {
                onCategorySelect(category)
              }
            )
            .id(category)
          }
        }
        .padding(.horizontal, 20)
      }
      .onChange(of: selectedCategory) { newCategory in
        withAnimation(.easeInOut(duration: 0.3)) {
          proxy.scrollTo(newCategory, anchor: .center)
        }
      }
    }
  }

  private func countForCategory(_ category: SearchCategory) -> Int {
    switch category {
    case .all:
      return musicCount + movieCount + podcastCount + etcCount
    case .music:
      return musicCount
    case .movies:
      return movieCount
    case .podcast:
      return podcastCount
    case .etc:
      return etcCount
    }
  }
}

struct CategoryTab: View {
  let category: SearchCategory
  let isSelected: Bool
  let count: Int
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      HStack(spacing: 6) {
        Text(category.rawValue)
          .font(.pretendardFont(family: isSelected ? .semiBold : .medium, size: 16))

        if count > 0 {
          Text("\(count)")
            .font(.pretendardFont(family: .medium, size: 14))
            .foregroundStyle(isSelected ? .black : .gray)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
              RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? .green : .gray.opacity(0.3))
            )
        }
      }
      .foregroundStyle(isSelected ? .black : .gray)
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(
        RoundedRectangle(cornerRadius: 20, style: .continuous)
          .fill(isSelected ? .green : .clear)
          .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
              .stroke(isSelected ? .green : .gray.opacity(0.3), lineWidth: 1)
          )
      )
    }
    .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  VStack(spacing: 20) {
    SearchCategoryFilter(
      selectedCategory: .all,
      musicCount: 15,
      movieCount: 3,
      podcastCount: 1,
      etcCount: 2
    )

    SearchCategoryFilter(
      selectedCategory: .music,
      musicCount: 15,
      movieCount: 3,
      podcastCount: 1,
      etcCount: 2
    )
  }
  .background(Color.black)
}