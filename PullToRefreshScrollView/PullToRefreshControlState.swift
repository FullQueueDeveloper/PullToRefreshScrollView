//
//  PullToRefreshControlState.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

enum PullToRefreshControlState: Equatable {
  case atRest // default state

  case possible(CGFloat) // interaction has started

  case triggered // scrolled down far enough to trigger the refresh

  case waitingOnRefresh // interaction has ended, but refresh hasn't completed yet

  case interactionOngoingRefreshComplete // interaction still ongoing, and refresh has completed
}
