//
//  PullToRefreshPossibleView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

public struct PullToRefreshInteractiveView: View {
  let color: Color
  let foregroundColor: Color
  let value: CGFloat // 0.0 to 1.0

  public init(color: Color, foregroundColor: Color, value: CGFloat) {
    self.color = color
    self.foregroundColor = foregroundColor
    self.value = value
  }

  public var body: some View {
    ZStack {

      Ellipse()
        .foregroundColor(adjustedTintColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      Image(systemName: "arrow.clockwise")
        .foregroundColor(foregroundColor)

        .rotationEffect(.degrees(180 * value * 1.1))
        .font(Font.title2.bold())
    }
    .scaleEffect(0.4 + value * 0.6)
  }

  var adjustedTintColor: Color {
    if value < 0.8 {
      return color.opacity(Double(value))
    } else {
      return color
    }
  }
}
