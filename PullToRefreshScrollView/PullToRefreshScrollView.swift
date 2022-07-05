//
//  PullToRefreshScrollView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

public struct PullToRefreshScrollView<RefreshContent: View, Content: View>: View {

  let threshold: CGFloat
  let refreshContent: (PullToRefreshControlState) -> RefreshContent
  let content: () -> Content

  @StateObject private var controller: PullToRefreshController

  public init(threshold: CGFloat = 100,
              action: @escaping () async -> Void,
              @ViewBuilder refreshContent: @escaping (PullToRefreshControlState) -> RefreshContent,
              @ViewBuilder content: @escaping () -> Content) {
    self.threshold = threshold
    self.refreshContent = refreshContent
    self.content = content

    self._controller = StateObject(wrappedValue: PullToRefreshController(threshold: threshold, action: action))
  }


  @State var contentPadding: CGFloat = 0

  public var body: some View {

    ZStack(alignment: .top) {

      refreshContent(controller.refreshControlState)

      GeometryReader { geo in
        ScrollView {
          content()
            .anchorPreference(key: PullToRefreshDistancePreferenceKey.self, value: .top) {
              geo[$0].y
            }
            .padding(.top, contentPadding)
        }
      }
    }
    .onPreferenceChange(PullToRefreshDistancePreferenceKey.self) { offset in
      controller.offset = offset
    }
    .onChange(of: controller.refreshControlState) { newValue in
      withAnimation(.easeInOut) {
        self.contentPadding = contentPadding(refreshControlState: newValue)
      }
    }
  }

  func contentPadding(refreshControlState: PullToRefreshControlState) -> CGFloat {
    switch refreshControlState {
    case .possible, .atRest, .interactionOngoingRefreshComplete:
      return 0
    case .triggered:
      return threshold * 0.5
    case .waitingOnRefresh:
      return threshold * 0.5
    }
  }
}
