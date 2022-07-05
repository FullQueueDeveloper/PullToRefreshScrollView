//
//  DefaultRefreshView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/5/22.
//

import SwiftUI
import Combine

public struct DefaultRefreshView: View {

  let color: Color
  let foregroundColor: Color

  @State var value: CGFloat = 0 // 0.0 to 1.0
  @State var timer = Timer.TimerPublisher(interval: 0.01,
                                          runLoop: .current,
                                          mode: .common)
    .autoconnect()
  @State var cancellable: Cancellable?

  public init(color: Color, foregroundColor: Color) {
    self.color = color
    self.foregroundColor = foregroundColor
  }

  public var body: some View {
    ZStack {

      Ellipse()
        .foregroundColor(color)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      Image(systemName: "arrow.clockwise")
        .foregroundColor(foregroundColor)

        .rotationEffect(.degrees(360 * value))
        .font(Font.title2.bold())
    }
    .frame(width: 35, height: 35)
    .padding(2)
    .onReceive(timer, perform: { _ in

      let newValue = (value + 0.01)
      self.value = newValue > 1.0
                    ? 0.01
                    : newValue
    })
//    .onAppear() {
//      print("spinner appeared")
//      cancellable = timer.connect()
//    }
//    .onDisappear() {
//      cancellable?.cancel()
//      cancellable = nil
//    }
  }
}
