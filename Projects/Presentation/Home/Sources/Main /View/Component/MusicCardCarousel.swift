//
//  MusicCardCarousel.swift
//  Home
//
//  Created by Wonji Suh  on 10/23/25.
//

import Core
import SwiftUI

public struct MusicCardCarousel: View {
  @State private var currentIndex = 0

  private let items: [MusicItem]
  private let cardHeight: CGFloat
  private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
  private var tapAction: (MusicItem) -> Void = { _ in }


  public init(
    items: [MusicItem],
    cardHeight: CGFloat = 280,
    tapAction: @escaping(MusicItem) -> Void
  ) {
    self.items = items
    self.cardHeight = cardHeight
    self.tapAction = tapAction
  }

  public var body: some View {
    Group {
      if items.isEmpty {
        Color.clear
          .frame(height: cardHeight)
      } else {
        ScrollViewReader { proxy in
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
              ForEach(items) { item in
                MusicItemCard(item: item, size: cardHeight) {
                  tapAction(item)
                }
                  .id(item.id)
              }
            }
            .onReceive(timer) { _ in
              guard !items.isEmpty else { return }
              withAnimation(.easeInOut(duration: 1)) {
                currentIndex = (currentIndex + 1) % items.count
                proxy.scrollTo(items[currentIndex].id, anchor: .center)
              }
            }
          }
        }
        .frame(height: cardHeight)
        .padding(.bottom, 40)
      }
    }
  }
}
