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

  var body: some View {
    ScrollView {

      ZStack {
        PullToRefreshControl(coordinateSpaceName: coordinateSpaceName,
                           action: action)
        
        content()
      }
    }
    .coordinateSpace(name: coordinateSpaceName)
  }

  @State var uuid: UUID = UUID()
  var coordinateSpaceName: String {
    "pullToRefresh-\(uuid)"
  }
}
