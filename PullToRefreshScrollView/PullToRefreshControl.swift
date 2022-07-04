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
  let refreshContent: (PullToRefreshControlState) -> RefreshContent

  private let atRestDistance: CGFloat = 1

  var isInteractionActive: Bool {
    offset > atRestDistance
  }

  var body: some View {
    VStack {
      HStack {
        Spacer()
        refreshContent(refreshControlState)
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
