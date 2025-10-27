import SwiftUI
import DesignSystem

struct MusicItemCardSkeleton: View {
  var size: CGFloat = 200

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      SkeletonView(width: size, height: size, cornerRadius: 12)
        .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 8)

      Spacer().frame(height: 10)

      VStack(alignment: .leading, spacing: 6) {
        SkeletonView(width: size * 0.6, height: 12, cornerRadius: 6)
        SkeletonView(width: size * 0.8, height: 14, cornerRadius: 6)
        SkeletonView(width: size * 0.4, height: 12, cornerRadius: 6)
      }
      .padding(.horizontal, 4)
      .frame(width: size, alignment: .leading)
    }
    .frame(width: size)
  }
}

struct MusicCarouselSkeletonView: View {
  var height: CGFloat = 280

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        ForEach(0..<3, id: \.self) { _ in
          MusicItemCardSkeleton(size: height)
        }
      }
      .padding(.horizontal, 4)
    }
    .frame(height: height)
  }
}

struct MusicSectionSkeletonView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 10) {
        SkeletonView(width: 120, height: 16, cornerRadius: 8)

        Spacer()

        SkeletonView(width: 36, height: 36, cornerRadius: 18)
        SkeletonView(width: 36, height: 36, cornerRadius: 18)
      }

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
          ForEach(0..<4, id: \.self) { _ in
            MusicItemCardSkeleton(size: 160)
          }
        }
        .padding(.horizontal, 4)
      }
    }
  }
}
