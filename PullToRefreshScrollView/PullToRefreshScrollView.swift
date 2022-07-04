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

  @State
  var refreshControlState: PullToRefreshControlState = .atRest

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
  @State var contentPadding: CGFloat = 0

  var body: some View {

    ZStack {
      PullToRefreshControl(cliff: cliff, color: color, offset: $offset, refreshControlState: $refreshControlState, action: action)
//        .padding(.top, -10)
      ScrollView {
        VStack(spacing: 0) {

            Spacer()
              .frame(height: contentPadding)


          content()

        }
        .background(PullToRefreshDistanceView(
          offset: $offset,
          coordinateSpaceName: coordinateSpaceName))
      }
      .coordinateSpace(name: coordinateSpaceName)
    }
    .onChange(of: refreshControlState) { newValue in
      withAnimation(.easeInOut) {
        self.contentPadding = contentPadding(refreshControlState: newValue)
      }
    }
  }

  func contentPadding(refreshControlState: PullToRefreshControlState) -> CGFloat {
    switch refreshControlState {
    case .atRest: return 0
    case .possible: return 0
    case .triggered, .waitingOnRefresh:
      return cliff * 0.25
    case .interactionOngoingRefreshComplete:
      return 0
    }
  }

  @State var uuid: UUID = UUID()
  var coordinateSpaceName: String {
    "pullToRefresh-\(uuid)"
  }
}
