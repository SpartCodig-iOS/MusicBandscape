//
//  NavigationArrowButton.swift
//  Detail
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI

import DesignSystem

public struct NavigationArrowButton: View {

  private var backAction: () -> Void = {}

  public init(
    backAction: @escaping () -> Void
  ) {
    self.backAction = backAction
  }

  public var body: some View {
    HStack {
      Button(action: {
        backAction()
      }) {
        Image(systemName: "chevron.left")
          .resizable()
          .scaledToFit()
          .frame(width: 16, height: 24)
          .font(.pretendardFont(family: .semiBold, size: 20))
          .foregroundStyle(.white)
          .padding(16)
          .background(Color.lightGray100.opacity(0.6))
          .clipShape(Circle())
      }
      .buttonStyle(PlainButtonStyle())

      Spacer()

    }
    .padding(.horizontal, 16)
  }
}

