//
//  PullToRefreshDistanceView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct PullToRefreshDistanceView: View {

  @Binding var offset: CGFloat
  let coordinateSpaceName: String

  var body: some View {
    GeometryReader { geo in
      Rectangle()
        
        .foregroundColor(.clear)
        .preference(key: PullToRefreshDistancePreferenceKey.self,
                    value: [geo.frame(in: .named(coordinateSpaceName))])
        .onPreferenceChange(PullToRefreshDistancePreferenceKey.self) { frames in
          guard let frame = frames.first else {
            return
          }
          let offset = frame.minY
          self.offset = offset
        }
    }
  }
}
