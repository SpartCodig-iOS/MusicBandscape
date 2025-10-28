//
//  SearchView.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import ComposableArchitecture
import Shared

public struct SearchView: View {
  @Perception.Bindable public var store: StoreOf<SearchReducer>

  public init(store: StoreOf<SearchReducer>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      ZStack {
        SearchBackground()
          .ignoresSafeArea()

        VStack(spacing: 0) {
          // 고정된 검색바와 Cancel 버튼
          HStack(spacing: 12) {
            SearchBar(
              searchText: store.searchText,
              onTextChange: { text in
                store.send(.view(.searchTextChanged(text)))
              },
              onSearchSubmit: { searchText in
                store.send(.view(.searchSubmitted(searchText)))
              },
              onClearSearch: {
                store.send(.view(.clearSearch))
              }
            )

            // Cancel 버튼
            if !store.searchText.isEmpty || !store.currentSearchQuery.isEmpty {
              Button(action: {
                store.send(.view(.clearSearch))
              }) {
                Text("Cancel")
                  .font(.pretendardFont(family: .medium, size: 16))
                  .foregroundStyle(.green)
              }
              .buttonStyle(PlainButtonStyle())
              .padding(.trailing, 16)
            }
          }
          .padding(.top, 8)

          // 검색을 했을 때 카테고리 필터 표시
          if !store.currentSearchQuery.isEmpty {
            SearchCategoryFilter(
              selectedCategory: store.selectedCategory,
              musicCount: store.allSearchResults.count,
              movieCount: store.filteredSearchResults.count,
              podcastCount: store.filteredSearchResults.count,
              etcCount: store.filteredSearchResults.count,
              onCategorySelect: { category in
                store.send(.view(.selectCategory(category)))
              }
            )
            .padding(.top, 12)
          }

          // 스크롤 가능한 컨텐츠
          ScrollView {
            VStack(spacing: 24) {
              if !store.filteredSearchResults.isEmpty {
                SearchResultsList(
                  searchResults: store.filteredSearchResults,
                  onTapMusicItem: { musicItem in
                    store.send(.navigation(.selectMusicItem(musicItem)))
                  }
                )
              } else if !store.currentSearchQuery.isEmpty && store.allSearchResults.isEmpty {
                NoResultsView(searchQuery: store.currentSearchQuery) { suggestion in
                  store.send(.view(.selectRecentSearch(suggestion)))
                }
              } else if !store.allSearchResults.isEmpty && store.filteredSearchResults.isEmpty {
                NoResultsView(searchQuery: store.currentSearchQuery) { suggestion in
                  store.send(.view(.selectRecentSearch(suggestion)))
                }
              } else {

                RecentSearchesSection(
                  recentSearches: store.recentSearches,
                  onTapSearch: { searchText in
                    store.send(.view(.selectRecentSearch(searchText)))
                  }
                )

                TrendingSection(
                  onTap: { trendingItem in
                    store.send(.view(.selectTrendingItem(trendingItem.title)))
                  }
                )
              }

              Spacer(minLength: 100)
            }
            .padding(.top, 16)
          }
          .scrollIndicators(.hidden)
          .onAppear {
            UIScrollView.appearance().bounces = false
          }
        }
      }
    }
  }
}
