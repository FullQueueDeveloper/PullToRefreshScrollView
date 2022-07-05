//
//  PullToRefreshScrollView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

public struct PullToRefreshScrollView<RefreshContent: View,
                                        InteractiveContent: View,
                                        Content: View>: View {

  let threshold: CGFloat
  let interactiveContent: (CGFloat) -> InteractiveContent
  let refreshContent: () -> RefreshContent
  let content: () -> Content
  @State var refreshContentHeight: CGFloat = 0

  @StateObject private var controller: PullToRefreshController

  public init(threshold: CGFloat = 100,
              action: @escaping () async -> Void,
              @ViewBuilder interactiveContent: @escaping (CGFloat) -> InteractiveContent,
              @ViewBuilder refreshContent: @escaping () -> RefreshContent,
              @ViewBuilder content: @escaping () -> Content) {
    self.threshold = threshold
    self.interactiveContent = interactiveContent
    self.refreshContent = refreshContent
    self.content = content

    self._controller = StateObject(wrappedValue: PullToRefreshController(threshold: threshold, action: action))
  }

  @State var contentPadding: CGFloat = 0

  public var body: some View {

    GeometryReader { geo in
      ZStack(alignment: .top) {

        if case .possible(let value) = controller.refreshControlState, value > 0  {
          interactiveContent(value)
        }

        if controller.isSpinnerVisibleInZStack {
          refreshContent()
        }


        ScrollView {

          if controller.isSpinnerVisibleInScrollView {
            refreshContent()
          }

          content()
            .anchorPreference(key: PullToRefreshDistancePreferenceKey.self, value: .top) {
              geo[$0].y
            }

        }
      }
    }
    .onPreferenceChange(RefreshContentHeightPreferenceKey.self, perform: { height in
      print(height)
    })
    .onPreferenceChange(PullToRefreshDistancePreferenceKey.self) { offset in
      controller.offset = offset
    }
  }
}
