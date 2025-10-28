//
//  ScalingHeaderDetailView.swift
//  Detail
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct ScalingHeaderDetailView<Content: View>: View {
  let headerURL: URL?
  let isLoading: Bool
  let headerHeight: CGFloat
  let content: Content
  let store: StoreOf<DetailReducer>

  init(
    headerURL: URL?,
    isLoading: Bool,
    headerHeight: CGFloat = 400,
    store: StoreOf<DetailReducer>,
    @ViewBuilder content: () -> Content
  ) {
    self.headerURL = headerURL
    self.isLoading = isLoading
    self.headerHeight = headerHeight
    self.store = store
    self.content = content()
  }

  var body: some View {
    GeometryReader { outerGeo in
      ZStack(alignment: .topLeading) {
        ScrollView(showsIndicators: false) {
          VStack(spacing: 0) {
            GeometryReader { geo in
              let offset = geo.frame(in: .global).minY
              let height = offset > 0 ? headerHeight + offset : headerHeight
              headerContent
              .frame(width: outerGeo.size.width, height: height)
              .clipped()
              .offset(y: offset > 0 ? -offset : 0)
            }
            .frame(height: headerHeight) // 헤더 영역 고정

            // 헤더 아래 콘텐츠
            VStack(alignment: .leading, spacing: 16) {
              content
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
          }
        }

        NavigationArrowButton {
          print("🔥 ScalingHeaderDetailView: NavigationArrowButton 탭됨")
          store.send(.navigation(.backToHome))
        }
        .padding(.leading, 16)
        .padding(.top, outerGeo.safeAreaInsets.top + 20)
      }
      .ignoresSafeArea(edges: .top)
    }
  }

  @ViewBuilder
  private var headerContent: some View {
    if isLoading {
      SkeletonView(width: nil, height: headerHeight)
    } else {
      AsyncImage(url: headerURL) { phase in
        switch phase {
          case .empty:
            SkeletonView(width: nil, height: headerHeight)
          case .success(let image):
            image
              .resizable()
              .scaledToFill()
          case .failure:
            Image(systemName: "music.note")
              .resizable()
              .scaledToFit()
              .foregroundColor(.gray)
          @unknown default:
            Color.clear
        }
      }
    }
  }
}
