import SwiftUI
import Presentation
import Splash
import ComposableArchitecture

public struct ContentView: View {
    public init() {}

    public var body: some View {
        Text("Hello, World!")
            .padding()
    }
}


#Preview {
  ContentView()
}

#Preview("스플래쉬 화면") {
  SplashView(
    store: .init(
      initialState: SplashReducer.State(),
      reducer: {
        SplashReducer()
      })
  )
}

#Preview("홈 코디네이터 화면") {
  HomeCoordinatorView(store: .init(initialState: HomeCoordinator.State(), reducer: {
    HomeCoordinator()
  }))
}

#Preview("홈 화면 ") {
  HomeView(
    store: .init(
      initialState: HomeReducer.State(),
      reducer: {
        HomeReducer()
      })
  )
}

#Preview("상세 화면") {
  DetailView(
    store: .init(
      initialState: DetailReducer.State(musicItem: .detailMusicItem),
      reducer: {
        DetailReducer()
      })
  )
}
