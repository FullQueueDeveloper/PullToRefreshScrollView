//
//  PullToRefreshPossibleView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshPossibleView: View {
  let value: Float // 0.0 to 1.0

//  @Environment(\.accentColor)

  var width: CGFloat {
    if value < 0.3 {
      return CGFloat(value) * 100
    } else {
      return 30
    }
  }

  @ViewBuilder
  var shape: some View {
    if value < 0.3 {
       Circle()
    } else { //if value < 0.8 {
      RoundedRectangle(cornerRadius: 16)
    } //else {
//      Ellipse()
//      RoundedRectangle(cornerRadius: CGFloat(value) * 16)
//    }
  }

  var body: some View {
    shape
      .frame(width: width, height: CGFloat(value) * 100, alignment: .top)
      .aspectRatio(contentMode: .fill)
      .foregroundColor(fg)
      .padding()
  }

  var fg: Color {
    if value < 0.8 {
      return .accentColor.opacity(Double(value))
    } else {
      return .accentColor
    }
  }

}
