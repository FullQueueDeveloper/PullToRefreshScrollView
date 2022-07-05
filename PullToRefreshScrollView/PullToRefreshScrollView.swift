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
  @State var refreshContentHeight: CGFloat = 0

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

    GeometryReader { geo in
      ScrollView {

        MyLayout(controller: controller)({
          refreshContent(controller.refreshControlState)
          content()
            .anchorPreference(key: PullToRefreshDistancePreferenceKey.self, value: .top) {
              geo[$0].y
            }
        })
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


struct MyLayout: Layout {

  let controller: PullToRefreshController

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    proposal.replacingUnspecifiedDimensions(by: .init(width: 50, height: 50))
  }

  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {

    if subviews.count == 2 {
      let spinner = subviews.first!
      let spinnerSize = spinner.sizeThatFits(proposal)
      spinner.place(at: .zero, proposal: proposal)

      subviews.last!.place(at: CGPoint(x: 0, y: spinnerSize.height),
                           proposal: ProposedViewSize(width: proposal.width ?? 0, height: (proposal.height ?? 0) - spinnerSize.height))
      controller.spinnerHeight = spinnerSize.height
    } else {
      controller.spinnerHeight = 0
      subviews.first!.place(at: .zero, proposal: proposal)
    }
  }
}
