//
//  PullToRefreshScrollView.DistancePreferenceKey.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshDistancePreferenceKey: PreferenceKey {
  static var defaultValue: [CGRect] = []

  static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
    value = nextValue()
  }

  typealias Value = [CGRect]

}
