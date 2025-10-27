//
//  DetailView.swift
//  Detail
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI

import ComposableArchitecture

import Shared
import Core


public struct DetailView: View {
  @Perception.Bindable public var store: StoreOf<DetailReducer>

  public init(store: StoreOf<DetailReducer>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      ScalingHeaderDetailView(
        headerURL: store.musicItem?.highResolutionArtworkURL,
        headerHeight: 400,
        backAction: {
          // Your navigation logic for going back
        }
      ) {
        VStack {
          sectionHeaderContent(item: store.musicItem ??  .detailMusicItem)

          aboutAlbumInfoView(item: store.musicItem ?? .detailMusicItem)
        }
      }
      .background(Color.black.ignoresSafeArea())
      .onAppear {
        print("DetailView: item \(store.musicItem as Any)")
      }
    }
  }
}



extension DetailView {

  @ViewBuilder
  private func sectionHeaderContent(item : MusicItem) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Spacer()
        .frame(height: 30)

      HStack {
        Text(item.album)
          .font(.pretendardFont(family: .semiBold, size: 40))
          .foregroundStyle(.white)

        Spacer()
      }

      Text(item.artist)
        .font(.pretendardFont(family: .semiBold, size: 24))
        .foregroundStyle(.lightGray100)

      Text(item.trackName)
        .font(.pretendardFont(family: .semiBold, size: 20))
        .foregroundStyle(.lightGray100)


      Spacer()
        .frame(height: 10)
    }
  }

  @ViewBuilder
  private func aboutAlbumInfoView(item : MusicItem) -> some View {
    VStack(spacing: 10) {
      HStack {
        Text("About this track")
          .font(.pretendardFont(family: .semiBold, size: 24))
          .foregroundStyle(.white)

        Spacer()
      }

      Spacer()
        .frame(height: 5)

      Divider()
        .frame(height: 1)
        .background(.nightRider)

      HStack {
        Text(item.aboutAlbumInfo)
          .font(.pretendardFont(family: .semiBold, size: 20))
          .foregroundStyle(.lightGray100)

        Spacer()
      }
    }
  }
}


