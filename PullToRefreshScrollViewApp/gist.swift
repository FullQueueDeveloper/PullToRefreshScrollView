import Foundation
//
//  ContentView.swift
//  PullToRefresh
//
//  Created by Angelo Walczak on 02.07.22.
//

import SwiftUI

struct GistContentView: View {
  @State var actionState: RefreshableScrollViewActionState = .idle
  @State var data: [UUID] = [UUID()]

  var body: some View {
    RefreshableScrollView(threshold: 50, actionState: $actionState) {

        try! await Task.sleep(nanoseconds: 3_000_000_000) //do something for 3 seconds

      await MainActor.run {
        self.data = [UUID(), UUID(), UUID(), UUID(), UUID()]
        withAnimation {
          actionState = .idle
        }
      }
    } refreshContent: {
      Group {
        switch actionState {
        case .idle:
          ProgressView(value: 0)
        case .changing(let fraction):
          PullToRefreshInteractiveView(color: .purple, foregroundColor: .orange, value: CGFloat(fraction))
            .frame(width: 40, height: 40)
        case .pending:
          DefaultRefreshView(color: .green, foregroundColor: .yellow)
        }
      }
      .padding()
    } content: {
      ForEach(data.map{ $0.uuidString }, id: \.self) { item in
        Text(item)
      }
    }
  }
}

public enum RefreshableScrollViewActionState: Equatable {
  case idle
  case changing(_ fraction: Float)
  case pending
}

public struct RefreshableScrollView<Content: View, RefreshContent: View>: View {
  @Binding private var actionState: RefreshableScrollViewActionState

  let threshold: CGFloat
  let content: () -> Content
  let refreshContent: () -> RefreshContent
  let action: () async -> Void

  public init(
    threshold: CGFloat = 40,
    actionState: Binding<RefreshableScrollViewActionState>,
    action: @escaping () async -> Void,
    @ViewBuilder refreshContent: @escaping () -> RefreshContent,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.threshold = threshold
    self._actionState = actionState
    self.content = content
    self.refreshContent = refreshContent
    self.action = action
  }

  @State private var refreshContentHeight: CGFloat = 0

  var topPadding: CGFloat {
    switch actionState {
    case .idle:
      return 0
    case .changing(let fraction):
      return refreshContentHeight * CGFloat(fraction)
    case .pending:
      return refreshContentHeight
    }
  }

  public var body: some View {
    ZStack(alignment: .top) {
      if actionState != .idle {
        refreshContent()
          .transformEffect(.identity.translatedBy(x: 0, y: topPadding - refreshContentHeight))
          .overlay(
            GeometryReader { geo in
              Rectangle()
                .fill(Color.clear)
                .preference(key: HeightPreferenceKey.self, value: geo.size.height)
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                  refreshContentHeight = height
                }
            }
          )
      }

      GeometryReader { geo in
        ScrollView {
          content()
            .padding(.top, topPadding)
            .anchorPreference(key: OffsetPreferenceKey.self, value: .top) {
              geo[$0].y
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(OffsetPreferenceKey.self) { offset in
          guard actionState != .pending else {
            return
          }

          if offset > threshold {
            withAnimation {
              actionState = .pending
              Task(priority: .userInitiated) {
                await action()
              }
            }
          }
          else if offset <= 0 {
            withAnimation {
              actionState = .idle
            }
          }
          else {
            actionState = .changing(Float(offset/threshold))
          }
        }
      }
    }
  }
}

fileprivate struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

fileprivate struct HeightPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
