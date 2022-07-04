//
//  PullToRefreshScrollView.Control.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshControl: View {

  let cliff: CGFloat
  let color: Color
  @Binding var offset: CGFloat
  @Binding var refreshControlState: PullToRefreshControlState
  let action: () async -> Void

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
          PullToRefreshPossibleView(cliff: cliff, color: color, value: value)
            
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
    .onChange(of: refreshControlState, perform: { newValue in
      print(newValue)
    })
  }

  func update() {
    if isInteractionActive {
      switch refreshControlState {
      case .atRest:
        self.refreshControlState = .possible(min(cliff, offset)/cliff)
      case .possible:
        if offset < cliff {
          self.refreshControlState = .possible(min(cliff, offset)/cliff)
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
