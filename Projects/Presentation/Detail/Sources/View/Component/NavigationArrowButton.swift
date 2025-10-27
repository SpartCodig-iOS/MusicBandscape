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
      Image(systemName: "chevron.left")
        .resizable()
        .scaledToFit()
        .frame(width: 12, height: 20)
        .font(.pretendardFont(family: .semiBold, size: 20))
        .foregroundStyle(.white)
        .onTapGesture(perform: backAction)

      Spacer()

    }
    .padding(.horizontal, 16)
  }
}

