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
//  private let atRestDistance: CGFloat = 1

  var spinnerHeight: CGFloat = 0
  
  @Published var offset: CGFloat = 0 {
    didSet {
      update()
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

  var isInteractionActive: Bool {
    offset > spinnerHeight
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

  var isSpinnerVisible: Bool {
    switch refreshControlState {
    case .atRest:
      return false
    case .possible:
      return false
    case .interactionOngoingRefreshComplete:
      return false
    case .triggered, .waitingOnRefresh:
      return true
    }
  }
}
