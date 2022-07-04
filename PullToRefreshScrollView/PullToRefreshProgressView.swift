//
//  PullToRefreshProgressView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshProgressView: View {

  let value: CGFloat

  var body: some View {

    ZStack {

      Pill()
        .rotationEffect(.degrees(0))

      Pill()
        .offset(x: 10, y: 0)
        .rotationEffect(.degrees(30))

      Pill()
        .offset(x: 15, y: 0)
        .rotationEffect(.degrees(60))

      Pill()
        .offset(x: 0, y: 40)
        .rotationEffect(.degrees(90))

    }
    .opacity(value)
  }

  struct Pill: View {

    var body: some View {
      RoundedRectangle(cornerRadius: 16)
        .frame(width: 6, height: 12)
    }
  }
}

#if DEBUG
struct MyPreviewProvider_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PullToRefreshProgressView(value: 0.1)
      PullToRefreshProgressView(value: 0.3)
    }
    .previewLayout(.fixed(width: 60, height: 60))
  }
}
#endif
