//
//  SplashView.swift
//  Splash
//
//  Created by Wonji Suh  on 10/22/25.
//

import SwiftUI

import ComposableArchitecture

import Shared

@ViewAction(for: SplashReducer.self)
public struct SplashView: View {
  @Perception.Bindable public var store: StoreOf<SplashReducer>


  public init(store: StoreOf<SplashReducer>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      ZStack {
        LinearGradient(
          colors: [
            .backgroundBlack,
              .backgroundDark
          ],
          startPoint: .top,
          endPoint: .bottom
        )
        .ignoresSafeArea()

        LinearGradient(
          colors: [
            .accentSpring,
              .accentSummer,
              .accentAutumn,
              .accentWinter,
              .accentSpring
          ],
          startPoint: .topLeading, endPoint: .bottomTrailing)
        .opacity(0.20)
        .ignoresSafeArea()

        // MARK: Radial Glow
        Circle()
          .fill(.accentSpotify.opacity(0.6))
          .frame(width: 384, height: 384)
          .blur(radius: 60)
          .scaleEffect(store.pulse ? 1.05 : 0.95)
          .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: store.pulse)

        VStack(spacing: 0) {
          ZStack {
            Circle()
              .fill(.accentSpotify.opacity(0.4))
              .frame(width: 160 * 1.6, height: 160 * 1.6)
              .blur(radius: 30)
              .opacity(store.pulse ? 1.0 : 0.9)
              .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: store.pulse)

            Image(asset: .splashLogo)
              .frame(width: 160, height: 160)
              .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 6)
              .opacity(store.logoOpacity)
              .scaleEffect(store.logoScale)
              .animation(
                .easeInOut(duration: 1.2)
                .delay(0)
                .repeatCount(1, autoreverses: false),
                value: store.logoOpacity
              )
          }
          .padding(.bottom, 32)

          Text("Bandscape")
            .font(.pretendardFont(family: .bold, size: 48))
            .foregroundColor(.white)
            .kerning(-0.5)
            .opacity(store.textOpacity)
            .offset(y: store.textOffset)
            .animation(.easeInOut(duration: 1.2).delay(0.3), value: store.textOpacity)
            .animation(.easeInOut(duration: 1.2).delay(0.3), value: store.textOffset)
            .padding(.bottom, 24)

          Text("The Soundscape of Every Season")
            .font(.pretendardFont(family: .regular, size: 18))
            .foregroundStyle(.textSecondary)
            .multilineTextAlignment(.center)
            .opacity(store.subtitleOpacity)
            .offset(y: store.textOffset)
            .animation(.easeInOut(duration: 1.2).delay(0.5), value: store.subtitleOpacity)
        }
        .padding(.horizontal, 32)

        VStack {
          Spacer()
          Text("© 2025 Bandscape")
            .font(.pretendardFont(family: .light, size: 12))
            .foregroundStyle(.textSecondary.opacity(0.6))
            .opacity(store.footerOpacity)
            .animation(.easeInOut(duration: 1.2).delay(0.8), value: store.footerOpacity)
            .padding(.bottom, 32)
        }
        .ignoresSafeArea()

        Rectangle()
          .fill(.black)
          .opacity(0)
          .ignoresSafeArea()
      }
      .onAppear {
        send(.onAppear)
      }
    }
  }
}




