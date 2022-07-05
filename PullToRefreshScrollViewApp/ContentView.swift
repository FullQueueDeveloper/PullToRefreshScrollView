//
//  ContentView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct ContentView: View {
  @State var items: [UUID] = [UUID()]
  @State var spinnerValue: CGFloat = 0

  @State var timer = Timer.TimerPublisher(interval: 0.1, runLoop: .current, mode: .default).autoconnect()
  var body: some View {

    VStack(spacing: 0) {
      HStack {
        Text("Pull")
        Spacer()
        Text("To refresh")
      }
      .padding()
      .background(Color.gray)

      PullToRefreshScrollView {
        await refresh()
      } interactiveContent: { value in
        PullToRefreshInteractiveView(color: .purple,
                                 foregroundColor: .orange,
                                 value: value)
        .frame(width: 40, height: 40)
        .transformEffect(.identity.translatedBy(x: 0, y: -10 + 10 * value))
      } refreshContent: {
        DefaultRefreshView(color: .purple, foregroundColor: .white)
          .frame(width: 40, height: 40)
      } content: {
        VStack(alignment: .leading, spacing: 16) {
          ForEach(items, id: \.hashValue) { item in
            Text("\(item.uuidString)")
              .frame(maxWidth: .infinity)
          }
        }
      }
    }
  }

  func refresh() async {
    try! await Task.sleep(nanoseconds: 3000000000)
    await MainActor.run {
      items = [
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID(),
      ]
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
