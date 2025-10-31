//
//  RootTabBarView.swift
//  RootTab
//
//  Created by Wonji Suh  on 10/28/25.
//

import SwiftUI
import ComposableArchitecture
import Home
import Search

public struct RootTabBarView: View {
  @Perception.Bindable var store: StoreOf<RootTabReducer>

  public init(store: StoreOf<RootTabReducer>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      TabView(selection: $store.selectedTab) {
        HomeCoordinatorView(
          store: self.store.scope(
            state: \.homeCoordinator,
            action: \.scope.homeCoordinator)
        )
          .tabItem {
            Image(systemName: "house")
            Text(MainTab.home.tabBarTitle)
          }
          .tag(MainTab.home)

        SearchCoordinatorView(
          store: self.store.scope(
            state: \.searchCoordinator,
            action: \.scope.searchCoordinator)
        )
          .tabItem {
            Image(systemName: "magnifyingglass")
            Text(MainTab.search.tabBarTitle)
          }
          .tag(MainTab.search)
      }
      .preferredColorScheme(.dark)
      .accentColor(.green)
      .onAppear {
        setupTabBarAppearance()
      }
    }
  }

  private func setupTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.black

    // 선택되지 않은 탭 아이템 색상
    appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
      .foregroundColor: UIColor.gray
    ]

    // 선택된 탭 아이템 색상
    appearance.stackedLayoutAppearance.selected.iconColor = UIColor.green
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
      .foregroundColor: UIColor.green
    ]

    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }
}
