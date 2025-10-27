//
//  SectionHeaderView.swift
//  Home
//
//  Created by Wonji Suh  on 10/23/25.
//

import SwiftUI
import DesignSystem

struct SectionHeaderView: View {
  let headerText: String
  let onLeftTapped: () -> Void
  let onRightTapped: () -> Void

  var body: some View {
    HStack(spacing: 10) {
      Text(headerText)
        .font(.pretendardFont(family: .regular, size: 16))
        .foregroundStyle(.white)

      Spacer()

      CircularArrowButton(direction: .left, action: onLeftTapped)

      CircularArrowButton(direction: .right, action: onRightTapped)
    }
  }
}
