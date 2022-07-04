//
//  PullToRefreshScrollView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshScrollView<Content: View>: View {

  let action: () async -> Void
  let content: () -> Content

  @State var offset: CGFloat = 0

  var body: some View {

    ZStack {
      PullToRefreshControl(offset: $offset, action: action)

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
