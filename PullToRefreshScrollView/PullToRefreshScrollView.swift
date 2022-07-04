//
//  PullToRefreshScrollView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshScrollView<Content: View>: View {
  
  @Binding var refreshState: PullToRefreshControl.RefreshState

  let action: () -> Void
  let content: () -> Content

  var body: some View {
    ScrollView {
      PullToRefreshControl(coordinateSpaceName: coordinateSpaceName,
                           action: action,
                           refreshState: $refreshState)
      content()
    }
    .coordinateSpace(name: coordinateSpaceName)
  }

  @State var uuid: UUID = UUID()
  var coordinateSpaceName: String {
    "pullToRefresh-\(uuid)"
  }
}
