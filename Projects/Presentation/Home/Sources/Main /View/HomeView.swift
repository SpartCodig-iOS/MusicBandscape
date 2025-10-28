//
//  HomeView.swift
//  Home
//
//  Created by Wonji Suh  on 10/23/25.
//

import SwiftUI
import ComposableArchitecture
import Shared

@ViewAction(for: HomeReducer.self)
public struct HomeView: View {
  @Perception.Bindable public var store: StoreOf<HomeReducer>

  public init(
    store: StoreOf<HomeReducer>
  ) {
    self.store = store
  }

  public var body: some View {
    GeometryReader { proxy in
      WithPerceptionTracking {
        let horizontalPadding: CGFloat = 20
        let contentWidth = max(proxy.size.width - (horizontalPadding * 2), 0)
        let cardHeight: CGFloat = 200
        let searchBarHeight: CGFloat = 68

        ZStack(alignment: .top) {
          Color.backgroundBlack
            .ignoresSafeArea()

          ScrollView(.vertical) {
            Spacer()
              .frame(height: proxy.safeAreaInsets.top + searchBarHeight + 12)

            VStack(spacing: 0) {
              Group {
                if store.popularMusicModel.isEmpty {
                  MusicCarouselSkeletonView(height: cardHeight)
                } else {
                  MusicCardCarousel(
                    items: Array(store.popularMusicModel),
                    cardHeight: cardHeight,
                    tapAction: { item in
                      store.send(.navigation(.musicCardTapped(item: item)), animation: .easeIn)
                    }
                  )
                }
              }

              musicSeasonView()

            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, 12)
          }
          .scrollIndicators(.hidden)

          VStack(spacing: 8) {
            SearchBarView {
              store.send(.navigation(.tapSearch))
            }
              .padding(.horizontal, horizontalPadding)
          }
          .padding(.top, proxy.safeAreaInsets.top + 4)
          .ignoresSafeArea(edges: .top)
          .zIndex(1)
        }
      }
    }
    .onAppear {
      send(.onAppear)
    }
  }
}

extension HomeView {
  @ViewBuilder
  private func musicSeasonView() -> some View {
    LazyVStack {
      ForEach(MusicSeason.allCases.filter { $0 != .popular }) { season in
        let items = store.state.items(for: season)

        if items.isEmpty {
          MusicSectionSkeletonView()
            .padding(.top, 10)
        } else {
          MusicListSectionView(
            title: season.title,
            items: Array(items),    
            tapAction: { item in
              store.send(.navigation(.musicCardTapped(item: item)), animation: .easeIn)
            }
          )
          .padding(.top, 10)
        }
      }
    }
  }
}
