//
//  PullToRefreshScrollView.Control.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI


struct PullToRefreshControl: View {

  let atRestDistance: CGFloat = 0
  let cliff: CGFloat = 100.0
  let coordinateSpaceName: String
  let action: () async -> Void

  @State var offset: CGFloat = 0
  @State var refreshControlState: RefreshControlState = .atRest

  enum RefreshControlState: Equatable {
    case atRest // default state

    case possible(Float) // interaction has started

    case triggered // scrolled down far enough to trigger the refresh

    case waitingOnRefresh // interaction has ended, but refresh hasn't completed yet

    case interactionOngoingRefreshComplete // interaction still ongoing, and refresh has completed
  }

  var isInteractionActive: Bool {
    offset > atRestDistance
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
        let offset = frame.minY
        print("offset:", offset)
        self.offset = offset
        update()
      }
    }
    .onChange(of: refreshControlState, perform: { newValue in
      print(newValue)
    })
  }

  func update() {
    if isInteractionActive {
      switch refreshControlState {
      case .atRest:
        self.refreshControlState = .possible(Float(min(cliff, offset)/cliff))
      case .possible:
        if offset < cliff {
          self.refreshControlState = .possible(Float(min(cliff, offset)/cliff))
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
