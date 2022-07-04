//
//  PullToRefreshScrollView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshScrollView<Content: View>: View {

  let cliff: CGFloat
  let color: Color
  let action: () async -> Void
  let content: () -> Content

  init(cliff: CGFloat = 120,
       color: Color = .accentColor,
       action: @escaping () async -> Void,
       content: @escaping () -> Content) {
    self.cliff = cliff
    self.color = color
    self.action = action
    self.content = content
  }

  @State var offset: CGFloat = 0

  var body: some View {

    ZStack {
      PullToRefreshControl(cliff: cliff, color: color, offset: $offset, action: action)

      ScrollView {
        content()
          .background(PullToRefreshDistanceView(
            offset: $offset,
            coordinateSpaceName: coordinateSpaceName))
      }
      .coordinateSpace(name: coordinateSpaceName)
    }

  }

  @State var uuid: UUID = UUID()
  var coordinateSpaceName: String {
    "pullToRefresh-\(uuid)"
  }
}
