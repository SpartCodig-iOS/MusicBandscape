import SwiftUI

public struct SkeletonView: View {
  private let width: CGFloat?
  private let height: CGFloat
  private let cornerRadius: CGFloat
  private let baseColor: Color
  private let highlightColor: Color

  @State private var animate = false

  public init(
    width: CGFloat? = nil,
    height: CGFloat,
    cornerRadius: CGFloat = 12,
    baseColor: Color = Color.white.opacity(0.08),
    highlightColor: Color = Color.white.opacity(0.25)
  ) {
    self.width = width
    self.height = height
    self.cornerRadius = cornerRadius
    self.baseColor = baseColor
    self.highlightColor = highlightColor
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
      .fill(baseColor)
      .frame(width: width, height: height)
      .overlay(shimmerOverlay)
      .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
      .onAppear {
        guard !animate else { return }
        withAnimation(animation) {
          animate = true
        }
      }
  }

  private var animation: Animation {
    .linear(duration: 1.2).repeatForever(autoreverses: false)
  }

  private var shimmerOverlay: some View {
    GeometryReader { geometry in
      let overlayWidth = geometry.size.width == 0 ? (width ?? 120) : geometry.size.width
      let shimmerWidth = overlayWidth * 1.4

      LinearGradient(
        gradient: Gradient(colors: [
          baseColor.opacity(0.0),
          highlightColor,
          baseColor.opacity(0.0)
        ]),
        startPoint: .leading,
        endPoint: .trailing
      )
      .frame(width: shimmerWidth, height: geometry.size.height)
      .offset(x: animate ? overlayWidth : -shimmerWidth)
    }
  }
}
