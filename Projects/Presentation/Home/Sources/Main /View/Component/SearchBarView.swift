import SwiftUI
import DesignSystem

public struct SearchBarView: View {
  public init() {}

  public var body: some View {
    HStack(spacing: 10) {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.textSecondaryLight)
        .font(.pretendardFont(family: .semiBold, size: 20))

      Text("Search songs, podcasts, artists")
        .font(.pretendardFont(family: .regular, size: 15))
        .foregroundColor(.textSecondaryLight)

      Spacer(minLength: 0)
    }
    .padding(.horizontal, 14)
    .frame(height: 48)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(.neutralBlack)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(.white.opacity(0.05), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.2), radius: 3, y: 2)
    )
    .contentShape(Rectangle()) 
  }
}
