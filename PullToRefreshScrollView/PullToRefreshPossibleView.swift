//
//  PullToRefreshPossibleView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshPossibleView: View {
  let cliff: CGFloat
  let color: Color

  let value: CGFloat // 0.0 to 1.0

  var body: some View {
    ZStack {

      Ellipse()
        .frame(width: 0.3 * cliff,
               height: 0.3 * cliff)
        .foregroundColor(foregroundColor)
        .padding()

      Image(systemName: "arrow.clockwise")
        .foregroundColor(.white)

        .rotationEffect(.degrees(180 * value * 1.1))
        .font(Font.title2.bold())
    }
    .scaleEffect(value * 1.1)
  }

  var foregroundColor: Color {
    if value < 0.8 {
      return color.opacity(Double(value))
    } else {
      return color
    }
  }
}
