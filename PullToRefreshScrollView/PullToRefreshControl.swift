//
//  PullToRefreshScrollView.Control.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI


struct PullToRefreshControl: View {

  let coordinateSpaceName: String
  let action: () -> Void

  @Binding var refreshState: RefreshState

  private let cliff: Float = 100.0

  @State var offset: Float = 0
  @State var refreshControlState: RefreshControlState = .atRest

  enum RefreshState {
    case idle, active
  }

  enum RefreshControlState: Equatable {
    case atRest // default state

    case possible(Float) // interaction has started

    case triggered // scrolled down far enough to trigger the refresh

    case waitingOnRefresh // interaction has ended, but refresh hasn't completed yet

    case interactionOngoingRefreshComplete // interaction still ongoing, and refresh has completed
  }

  var body: some View {
    GeometryReader { geo in
      HStack {
        Spacer()
        switch refreshControlState {
        case .atRest:
          EmptyView()
        case .possible(let float):
          ProgressView(value: float)
            .padding()
        case .waitingOnRefresh,
            .triggered,
            .interactionOngoingRefreshComplete:
          ProgressView()
            .scaleEffect(2)
            .progressViewStyle(.circular)
        }
        Spacer()
      }
      .preference(key: PullToRefreshDistancePreferenceKey.self,
                  value: [geo.frame(in: .named(coordinateSpaceName))])
      .onPreferenceChange(PullToRefreshDistancePreferenceKey.self) { frames in
        guard let frame = frames.first else {
          return
        }
        let offset = frame.maxY
        self.offset = Float(offset)
        update()
      }
    }
    .onChange(of: refreshControlState, perform: { newValue in
      print(newValue)
    })
    .onChange(of: refreshState, perform: { newValue in
      switch newValue {
      case .active:
        return
      case .idle:
        switch refreshControlState {
        case .triggered:
          self.refreshControlState = .interactionOngoingRefreshComplete
        case .waitingOnRefresh:
          self.refreshControlState = .atRest
        case .interactionOngoingRefreshComplete, .atRest, .possible:
          break
        }
      }
    })
    .padding(.top, -0.5 * CGFloat(cliff))
  }

  func update() {
    if offset > 0 {
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
    action()
  }
}
