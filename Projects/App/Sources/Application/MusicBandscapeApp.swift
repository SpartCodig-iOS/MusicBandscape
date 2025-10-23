//
//  MusicBandscapeApp.swift
//  MusicBandscape
//
//  Created by Wonji Suh  on 10/22/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct MusicBandscapeApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate


  init() {

  }

  var body: some Scene {
    WindowGroup {
      let store = Store(initialState: AppReducer.State()) {
        AppReducer()
#if DEBUG
          ._printChanges()
          ._printChanges(.actionLabels)
#endif
      }

      AppView(store: store)
    }
  }
}
