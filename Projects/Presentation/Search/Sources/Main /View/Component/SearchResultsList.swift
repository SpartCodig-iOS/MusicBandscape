//
//  SearchResultsList.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem
import Core

struct SearchResultsList: View {
  let searchResults: [MusicItem]
  var onTapMusicItem: (MusicItem) -> Void = { _ in }

  var body: some View {
    LazyVStack(spacing: 0) {
      ForEach(searchResults) { musicItem in
        SearchResultItem(musicItem: musicItem) {
          onTapMusicItem(musicItem)
        }
        .background(Color.clear)
        .onTapGesture {
          onTapMusicItem(musicItem)
        }
      }
    }
  }
}

