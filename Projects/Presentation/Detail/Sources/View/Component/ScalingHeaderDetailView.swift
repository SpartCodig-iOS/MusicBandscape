//
//  ScalingHeaderDetailView.swift
//  Detail
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem

struct ScalingHeaderDetailView<Content: View>: View {
  let headerURL: URL?
  let headerHeight: CGFloat
  let content: Content
  let backAction: () -> Void

  init(
    headerURL: URL?,
    headerHeight: CGFloat = 400,
    backAction: @escaping () -> Void = {},
    @ViewBuilder content: () -> Content
  ) {
    self.headerURL = headerURL
    self.headerHeight = headerHeight
    self.content = content()
    self.backAction = backAction
  }

  var body: some View {
    GeometryReader { outerGeo in
      ZStack(alignment: .topLeading) {
        ScrollView(showsIndicators: false) {
          VStack(spacing: 0) {
            GeometryReader { geo in
              let offset = geo.frame(in: .global).minY
              let height = offset > 0 ? headerHeight + offset : headerHeight
              AsyncImage(url: headerURL) { phase in
                switch phase {
                  case .empty:
                    Color.gray.opacity(0.2)
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
          backAction()
        }
        .padding(.leading, 16)
        .padding(.top, outerGeo.safeAreaInsets.top + 20)
      }
      .ignoresSafeArea(edges: .top)
    }
  }
}
