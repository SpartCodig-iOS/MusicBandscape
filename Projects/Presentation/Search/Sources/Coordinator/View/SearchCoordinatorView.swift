//
//  SearchCoordinatorView.swift
//  Search
//
//  Created by Wonji Suh  on 10/28/25.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

import Detail

public struct SearchCoordinatorView: View {
  @Perception.Bindable var store: StoreOf<SearchCoordinator>

 public init(store: StoreOf<SearchCoordinator>) {
    self.store = store
  }

  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screens in
      switch screens.case {
        case .search(let searchStore):
          SearchView(store: searchStore)
            .navigationBarBackButtonHidden()

        case .detail(let detailStore):
          DetailView(store: detailStore)
            .navigationBarBackButtonHidden()
      }
    }
  }
}
