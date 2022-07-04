//
//  PullToRefreshPossibleView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshPossibleView: View {
  let value: Float // 0.0 to 1.0

  var width: CGFloat {
    if value < 0.25 {
      return CGFloat(value) * 100
    } else {
      return 25
    }
  }

  @ViewBuilder
  var shape: some View {
    if value < 0.2 {
      Circle()
    } else if value < 0.3 {
      RoundedRectangle(cornerRadius: 16)
    } else {
      Ellipse()
    }
  }

  var body: some View {
    shape
      .frame(width: width, height: CGFloat(value) * 100, alignment: .top)
      .foregroundColor(color)
      .padding()
  }

  var color: Color {
    if value < 0.7 {
      return .accentColor.opacity(Double(value))
    } else {
      return .accentColor
    }
  }
}
