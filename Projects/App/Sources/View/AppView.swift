//
//  AppView.swift
//  MusicBandscape
//
//  Created by Wonji Suh  on 10/22/25.
//

import SwiftUI

import ComposableArchitecture

import Presentation

struct AppView: View {
  var store: StoreOf<AppReducer>

  var body: some View {
    SwitchStore(store) { state in
      switch state {
        case .splash:
          if let store = store.scope(state: \.splash, action: \.scope.splash) {
            SplashView(store: store)
          }
      }
    }
  }
}
