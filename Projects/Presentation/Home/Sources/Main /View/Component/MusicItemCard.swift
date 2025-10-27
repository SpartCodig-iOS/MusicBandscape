//
//  MusicItemCard.swift
//  Home
//
//  Created by Wonji Suh  on 10/23/25.
//

import SwiftUI
import Core
import Shared

public struct MusicItemCard: View {
  private let item: MusicItem
  private var size: CGFloat = 200
  private var action: () -> Void = {  }

  public init(
    item: MusicItem,
    size: CGFloat = 200,
    action: @escaping() -> Void
  ) {
    self.item = item
    self.size = size
    self.action = action
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.clear)
          .shadow(color: .black.opacity(0.45), radius: 12, x: 0, y: 8)

        RoundedRectangle(cornerRadius: 12)
          .fill(Color.gray.opacity(0.2))
          .frame(width: size, height: size)
          .overlay(
            AsyncImage(
              url: item.highResolutionArtworkURL,
              transaction: Transaction(animation: .easeInOut(duration: 0.25))
            ) { phase in
              switch phase {
              case .empty:
                SkeletonView(width: size, height: size, cornerRadius: 12)

              case .success(let image):
                image
                  .resizable()
                  .interpolation(.high)
                  .aspectRatio(1, contentMode: .fill)
                  .frame(width: size, height: size)
                  .clipped()

              case .failure:
                Image(systemName: "music.note")
                  .font(.system(size: size * 0.2))
                  .foregroundColor(.gray)

              @unknown default:
                Color.clear
              }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
          )
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(.white.opacity(0.25), lineWidth: 1)
          )
      }
      .frame(width: size, height: size)
      .clipped()

      Spacer()
        .frame(height: 4)

      VStack(alignment: .leading, spacing: 3) {
        Text(item.album)
          .font(.pretendardFont(family: .semiBold, size: size * 0.06))
          .foregroundColor(.yellow)
          .lineLimit(2)
          .multilineTextAlignment(.leading)

        Text(item.trackName)
          .font(.pretendardFont(family: .semiBold, size: size * 0.08))
          .foregroundColor(.white)
          .lineLimit(2)
          .multilineTextAlignment(.leading)

        Text(item.artist)
          .font(.pretendardFont(family: .semiBold, size: size * 0.07))
          .foregroundColor(.textSecondary)
          .lineLimit(1)
      }
      .padding(.horizontal, 4)
      .frame(width: size, height: size * 0.35, alignment: .topLeading)
    }
    .onTapGesture(perform: action)
  }
}
