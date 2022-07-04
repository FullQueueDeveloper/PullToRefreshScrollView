//
//  PullToRefreshScrollView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

public struct PullToRefreshScrollView<RefreshContent: View, Content: View>: View {

  let threshold: CGFloat
  let color: Color
  let foregroundColor: Color
  let action: () async -> Void
  let refreshContent: (CGFloat) -> RefreshContent
  let content: () -> Content

  @State
  var refreshControlState: PullToRefreshControlState = .atRest

  public init(threshold: CGFloat = 120,
              color: Color = .accentColor,
              foregroundColor: Color = .white,
              action: @escaping () async -> Void,
              refreshContent: @escaping (CGFloat) -> RefreshContent,
              content: @escaping () -> Content) {
    self.threshold = threshold
    self.color = color
    self.foregroundColor = foregroundColor
    self.action = action
    self.refreshContent = refreshContent
    self.content = content
  }

  @State var offset: CGFloat = 0
  @State var contentPadding: CGFloat = 0

  public var body: some View {

    ZStack {
      PullToRefreshControl(threshold: threshold,
                           offset: $offset,
                           refreshControlState: $refreshControlState,
                           action: action,
                           refreshContent: refreshContent)
      GeometryReader { geo in
        ScrollView {
          VStack(spacing: 0) {

            Spacer()
              .frame(height: contentPadding)

            content()
              .anchorPreference(key: PullToRefreshDistancePreferenceKey.self, value: .top) {
                geo[$0].y
              }
          }
        }
      }
      .coordinateSpace(name: coordinateSpaceName)
    }
    .onPreferenceChange(PullToRefreshDistancePreferenceKey.self) { offset in
      self.offset = offset
    }
    .onChange(of: refreshControlState) { newValue in
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

  @State var uuid: UUID = UUID()
  var coordinateSpaceName: String {
    "pullToRefresh-\(uuid)"
  }
}
