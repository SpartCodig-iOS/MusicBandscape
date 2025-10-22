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

#Preview {
  SplashView(store: .init(initialState: SplashReducer.State(), reducer: {
    SplashReducer()
  }))
}

