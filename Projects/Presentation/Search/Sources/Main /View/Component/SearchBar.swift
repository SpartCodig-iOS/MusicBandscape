//
//  SearchBar.swift
//  Search
//
//  Created by Wonji Suh  on 10/27/25.
//

import SwiftUI
import DesignSystem

struct SearchBar: View {
  let searchText: String
  var onTextChange: (String) -> Void = { _ in }
  var onSearchSubmit: (String) -> Void = { _ in }
  var onClearSearch: () -> Void = {}

  @State private var internalText: String = ""

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: "magnifyingglass")
        .font(.pretendardFont(family: .medium, size: 16))
        .foregroundStyle(.gray)

      ZStack(alignment: .leading) {
        if internalText.isEmpty {
          Text("검색 할 영화 또는 음악을 입력하세요!")
            .font(.pretendardFont(family: .regular, size: 16))
            .foregroundStyle(.gray.opacity(0.6))
        }

        TextField("", text: $internalText)
          .font(.pretendardFont(family: .regular, size: 16))
          .foregroundStyle(.white)
          .submitLabel(.search)
          .onChange(of: internalText) { newValue in
            onTextChange(newValue)
          }
          .onSubmit {
            if !internalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
              onSearchSubmit(internalText)
            }
          }
      }

      if !internalText.isEmpty {
        Button(action: {
          internalText = ""
          onClearSearch()
        }) {
          Image(systemName: "xmark.circle.fill")
            .font(.system(size: 18))
            .foregroundStyle(.gray)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(.horizontal, 14)
    .frame(height: 48)
    .background(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .fill(.neutralBlack)
        .overlay(
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .stroke(.gray.opacity(0.2), lineWidth: 1)
        )
    )
    .padding(.leading, 16)
    .onAppear {
      internalText = searchText
    }
    .onChange(of: searchText) { newValue in
      internalText = newValue
    }
  }
}

#Preview {
  SearchBar(searchText: "")
    .background(Color.black)
}
