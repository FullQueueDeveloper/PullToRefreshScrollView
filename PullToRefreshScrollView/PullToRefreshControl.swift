//
//  PullToRefreshScrollView.Control.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshControl<RefreshContent: View>: View {

  let threshold: CGFloat
  @Binding var offset: CGFloat
  @Binding var refreshControlState: PullToRefreshControlState

  let action: () async -> Void
  let refreshContent: (CGFloat) -> RefreshContent

  private let atRestDistance: CGFloat = 1

  var isInteractionActive: Bool {
    offset > atRestDistance
  }

  var body: some View {
    VStack {
      HStack {
        Spacer()
        switch refreshControlState {
        case .atRest:
          EmptyView()
        case .possible(let value):
          refreshContent(value)
//          PullToRefreshContentView(threshold: threshold,
//                                    color: color,
//                                    foregroundColor: foregroundColor,
//                                    value: value)
//          .frame(width: 0.3 * threshold, height: 0.3 * threshold)

        case .waitingOnRefresh,
            .triggered,
            .interactionOngoingRefreshComplete:
          ProgressView()

            .progressViewStyle(.circular)
            .padding()
        }
        Spacer()
      }
      Spacer()
    }
    .onChange(of: offset, perform: { _ in update() })
  }

  func update() {
    if isInteractionActive {
      switch refreshControlState {
      case .atRest:
        self.refreshControlState = .possible(min(threshold, offset)/threshold)
      case .possible:
        if offset < threshold {
          self.refreshControlState = .possible(min(threshold, offset)/threshold)
        } else {
          triggerRefresh()
          self.refreshControlState = .triggered
        }
      case .waitingOnRefresh, .triggered, .interactionOngoingRefreshComplete:
        return
      }
    } else {
      switch refreshControlState {
      case .triggered:
        self.refreshControlState = .waitingOnRefresh
      case .possible:
        self.refreshControlState = .atRest
      case .interactionOngoingRefreshComplete:
        self.refreshControlState = .atRest
      case .atRest, .waitingOnRefresh:
        break
      }
    }
  }

  func triggerRefresh() {
    Task {
      await action()

      await MainActor.run {
        switch refreshControlState {
        case .atRest:
          break
        case .possible:
          break
        case .triggered:
          if isInteractionActive {
            self.refreshControlState = .interactionOngoingRefreshComplete
          } else {
            self.refreshControlState = .atRest
          }
        case .waitingOnRefresh:
          self.refreshControlState = .atRest
        case .interactionOngoingRefreshComplete:
         break
        }
      }
    }
  }
}
