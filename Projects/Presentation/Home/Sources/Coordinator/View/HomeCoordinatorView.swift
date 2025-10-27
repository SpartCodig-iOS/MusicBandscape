//
//  HomeCoordinatorView.swift
//  Home
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

import Detail

public struct HomeCoordinatorView: View {
  @Perception.Bindable var store: StoreOf<HomeCoordinator>

 public init(store: StoreOf<HomeCoordinator>) {
    self.store = store
  }

  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screens in
      switch screens.case {
        case .home(let homeStore):
          HomeView(store: homeStore)
            .navigationBarBackButtonHidden()

        case .detail(let detailStore):
          DetailView(store: detailStore)
      }
    }
  }
}
