import SwiftUI

public struct CircularArrowButton: View {
  public enum Direction {
    case left
    case right

    var systemName: String {
      switch self {
      case .left: return "chevron.left"
      case .right: return "chevron.right"
      }
    }
  }

  private let direction: Direction
  private let action: () -> Void
  private let size: CGFloat

  public init(
    direction: Direction,
    size: CGFloat = 36,
    action: @escaping () -> Void
  ) {
    self.direction = direction
    self.size = size
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      Image(systemName: direction.systemName)
        .font(.system(size: size * 0.45, weight: .semibold))
        .foregroundColor(.white)
        .frame(width: size, height: size)
        .background(Color.white.opacity(0.15))
        .clipShape(Circle())
        .overlay(
          Circle()
            .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
    .buttonStyle(.plain)
  }
}
