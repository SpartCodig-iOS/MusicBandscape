import SwiftUI
import DesignSystem

struct DetailSectionHeaderSkeletonView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Spacer().frame(height: 30)

      SkeletonView(width: 220, height: 36, cornerRadius: 10)
      SkeletonView(width: 160, height: 24, cornerRadius: 8)
      SkeletonView(width: 200, height: 20, cornerRadius: 8)

      Spacer().frame(height: 10)
    }
  }
}

struct DetailAboutAlbumSkeletonView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      SkeletonView(width: 180, height: 24, cornerRadius: 8)

      Spacer().frame(height: 5)

      SkeletonView(width: nil, height: 1, cornerRadius: 0, baseColor: Color.white.opacity(0.2))

      VStack(alignment: .leading, spacing: 8) {
        SkeletonView(width: nil, height: 14, cornerRadius: 6)
        SkeletonView(width: nil, height: 14, cornerRadius: 6)
        SkeletonView(width: 240, height: 14, cornerRadius: 6)
      }
    }
  }
}
