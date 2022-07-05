//
//  PullToRefreshController.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import Foundation
import SwiftUI

final class PullToRefreshController: ObservableObject {
  private let threshold: CGFloat
  private let action: () async -> ()
  private let atRestDistance: CGFloat = 1

  @Published var offset: CGFloat = 0 {
    didSet {
      update()
      print(refreshControlState)
    }
  }
  @Published var refreshControlState: PullToRefreshControlState = .atRest

  init(threshold: CGFloat, action: @escaping () async -> ()) {
    self.threshold = threshold
    self.action = action
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
      withAnimation(.easeInOut(duration: 0.15)) {
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
  }

  var isInteractionActive: Bool {
    offset > atRestDistance
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
              withAnimation {
                self.refreshControlState = .atRest
              }
            }
          case .waitingOnRefresh:
            withAnimation {
              self.refreshControlState = .atRest
            }
          case .interactionOngoingRefreshComplete:
            break
          }

      }
    }
  }

  var isSpinnerVisibleInScrollView: Bool {
    switch refreshControlState {
    case .atRest:
      return false
    case .possible:
      return false
    case .interactionOngoingRefreshComplete:
      return false
    case .triggered:
      return false
    case .waitingOnRefresh:
      return true
    }
  }

  var isSpinnerVisibleInZStack: Bool {
    switch refreshControlState {
    case .atRest, .possible:
      return false
    case .interactionOngoingRefreshComplete:
      return true
    case .triggered:
      return true
    case .waitingOnRefresh:
      return false
    }
  }
}
