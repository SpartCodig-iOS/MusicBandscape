//
//  SearchResultItem.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem
import Core
import Shared

struct SearchResultItem: View {
  let musicItem: MusicItem
  var onTap: () -> Void = {}

  var body: some View {
    HStack(spacing: 12) {
      // 앨범 아트워크
      AsyncImage(
        url: musicItem.artworkURL,
        transaction: Transaction(animation: .easeInOut(duration: 0.25))
      ) { phase in
        switch phase {
        case .empty:
          SkeletonView(width: 60, height: 60, cornerRadius: 8)

        case .success(let image):
          image
            .resizable()
            .interpolation(.high)
            .aspectRatio(1, contentMode: .fill)
            .frame(width: 60, height: 60)
            .clipped()

        case .failure:
          RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 60, height: 60)
            .overlay(
              Image(systemName: "music.note")
                .font(.system(size: 20))
                .foregroundColor(.gray)
            )

        @unknown default:
          Color.clear
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: 8))

      // 음악 정보
      VStack(alignment: .leading, spacing: 4) {
        Text(musicItem.trackName)
          .font(.pretendardFont(family: .semiBold, size: 16))
          .foregroundStyle(.white)
          .lineLimit(1)

        Text(musicItem.artist)
          .font(.pretendardFont(family: .medium, size: 14))
          .foregroundStyle(.textSecondary)
          .lineLimit(1)

        Text(musicItem.album)
          .font(.pretendardFont(family: .regular, size: 12))
          .foregroundStyle(.gray)
          .lineLimit(1)
      }

      Spacer()

    }
    .padding(.horizontal, 20)
    .padding(.vertical, 8)
    .contentShape(Rectangle())
    .onTapGesture(perform: onTap)
  }
}

