//
//  PullToRefreshScrollView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

public struct PullToRefreshScrollView<RefreshContent: View, Content: View>: View {
  private let atRestDistance: CGFloat = 1
  let threshold: CGFloat
  let color: Color
  let foregroundColor: Color
  let action: () async -> Void
  let refreshContent: (PullToRefreshControlState) -> RefreshContent
  let content: () -> Content

  @State
  var refreshControlState: PullToRefreshControlState = .atRest

  public init(threshold: CGFloat = 120,
              color: Color = .accentColor,
              foregroundColor: Color = .white,
              action: @escaping () async -> Void,
              @ViewBuilder refreshContent: @escaping (PullToRefreshControlState) -> RefreshContent,
              @ViewBuilder content: @escaping () -> Content) {
    self.threshold = threshold
    self.color = color
    self.foregroundColor = foregroundColor
    self.action = action
    self.refreshContent = refreshContent
    self.content = content
  }

  @State var offset: CGFloat = 0
  @State var contentPadding: CGFloat = 0

  public var body: some View {

    ZStack(alignment: .top) {

      refreshContent(refreshControlState)
      
      GeometryReader { geo in
        ScrollView {
          VStack(spacing: 0) {

            Spacer()
              .frame(height: contentPadding)

            content()
              .anchorPreference(key: PullToRefreshDistancePreferenceKey.self, value: .top) {
                geo[$0].y
              }
          }
        }
      }
    }
    .onPreferenceChange(PullToRefreshDistancePreferenceKey.self) { offset in
      self.offset = offset
    }
    .onChange(of: offset, perform: { _ in update() })
    .onChange(of: refreshControlState) { newValue in
      withAnimation(.easeInOut) {
        self.contentPadding = contentPadding(refreshControlState: newValue)
      }
    }
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

  func contentPadding(refreshControlState: PullToRefreshControlState) -> CGFloat {
    switch refreshControlState {
    case .possible, .atRest, .interactionOngoingRefreshComplete:
      return 0
    case .triggered:
      return threshold * 0.5
    case .waitingOnRefresh:
      return threshold * 0.5
    }
  }

  var isInteractionActive: Bool {
    offset > atRestDistance
  }
}
