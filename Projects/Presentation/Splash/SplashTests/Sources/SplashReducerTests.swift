//
//  SplashReducerTests.swift
//  SplashTests
//
//  Created by Wonji Suh  on 10/27/25.
//

import Testing
import ComposableArchitecture
@testable import Splash



extension Tag {
  @Tag static var mock: Self
  @Tag static var unit: Self
  @Tag static var reducer: Self
}

@MainActor
@Suite("Splash ReducerTest - 애니메이션  실행", .tags(.unit, .reducer))
struct SplashReducerTests {
  @Test("애니메이션 시퀀스가 올바른 순서로 진행" )
  func animationSequence_runsInOrder() async throws {
    let clock = TestClock()

    let store = TestStore(initialState: SplashReducer.State()) {
      SplashReducer()
    } withDependencies: {
      $0.continuousClock = clock
    }

    await store.send(.view(.onAppear))
    await store.receive(\.view.startAnimation)
    await store.receive(\.inner.startAnimationSequence) { state in
      state.pulse = true
    }

    await store.receive(\.inner.updateLogo) { state in
      state.logoOpacity = 1
      state.logoScale = 1
    }

    await clock.advance(by: .milliseconds(300))
    await store.receive(\.inner.updateText) { state in
      state.textOpacity = 1
      state.textOffset = 0
    }

    await clock.advance(by: .milliseconds(200))
    await store.receive(\.inner.updateSubtitle) { state in
      state.subtitleOpacity = 1
    }

    await clock.advance(by: .milliseconds(300))
    await store.receive(\.inner.updateFooter) { state in
      state.footerOpacity = 0.6
    }

    await clock.advance(by: .seconds(2))
    await store.receive(\.navigation.presentMain)

    await store.finish()
  }


  @Test("중복 시작 시 이전 애니메이션이 취소되고 새 시퀀스가 진행된다")
  func animationSequence_cancelInFlight() async throws {
    let clock = TestClock()
    let store = TestStore(
      initialState: SplashReducer.State()
    ) {
      SplashReducer()
    } withDependencies: {
      $0.continuousClock = clock
    }

    await store.send(.view(.onAppear))
    await store.receive(\.view.startAnimation)
    await store.receive(\.inner.startAnimationSequence) { state in
      state.pulse = true
    }
    await store.receive(\.inner.updateLogo) { state in
      state.logoOpacity = 1
      state.logoScale = 1
    }

    await store.send(.view(.onAppear))
    await store.receive(\.view.startAnimation)
    await store.receive(\.inner.startAnimationSequence)
    await store.receive(\.inner.updateLogo)

    await clock.advance(by: .milliseconds(300))
    await store.receive(\.inner.updateText) { state in
      state.textOpacity = 1
      state.textOffset = 0
    }
    #expect(store.state.textOpacity == 1)


    await clock.advance(by: .milliseconds(200))
    await store.receive(\.inner.updateSubtitle) { state in
      state.subtitleOpacity = 1
    }


    await clock.advance(by: .milliseconds(300))
    await store.receive(\.inner.updateFooter) { state in
      state.footerOpacity = 0.6
    }

    await clock.advance(by: .seconds(2))
    await store.receive(\.navigation.presentMain)
    await store.finish()
  }
}
