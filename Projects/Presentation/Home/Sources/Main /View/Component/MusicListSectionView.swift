//
//  MusicListSectionView.swift
//  Home
//
//  Created by Wonji Suh  on 10/23/25.
//

import SwiftUI
import Shared
import Core

public struct MusicListSectionView: View {
  @State private var currentIndex: Int = 0

  public let items: [MusicItem]
  public var title: String
  private var tapAction: (MusicItem) -> Void = { _ in }

  public init(
    title: String,
    items: [MusicItem],
    tapAction: @escaping(MusicItem) -> Void
  ) {
    self.title = title
    self.items = items
    self.tapAction = tapAction
  }

  private var lastIndex: Int { max(items.count - 1, 0) }

  public var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      SectionHeaderView(
        headerText: title,
        onLeftTapped: { scroll(direction: .left) },
        onRightTapped: { scroll(direction: .right) }
      )

      ScrollViewReader { proxy in
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(items) { item in
              MusicItemCard(item: item){
                tapAction(item)
              }
                .id(item.id)
            }
          }
        }
        .onChange(of: currentIndex) { newIndex in
          guard !items.isEmpty, newIndex >= 0, newIndex < items.count else { return }
          withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(items[newIndex].id, anchor: .center)
          }
        }
        .onAppear {
          guard !items.isEmpty else { return }
          proxy.scrollTo(items[0].id, anchor: .center)
        }
      }
    }
  }

  private enum ScrollDirection { case left, right }

  private func scroll(direction: ScrollDirection) {
    guard !items.isEmpty else { return }

    switch direction {
    case .left:
      if currentIndex > 0 {
        currentIndex -= 1
      }
    case .right:
      if currentIndex < lastIndex {
        currentIndex += 1
      } else {
        currentIndex = 0
      }
    }
  }
}
