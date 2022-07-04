//
//  ContentView.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

struct ContentView: View {
  @State var items: [UUID] = [UUID()]

  var body: some View {

    VStack(spacing: 0) {
      HStack {
        Text("Pull")
        Spacer()
        Text("To refresh")
      }
      .padding()
      .background(Color.gray)

      PullToRefreshScrollView(color: .accentColor) {
        await refresh()
      } refreshContent: { state in
        switch state {
        case .atRest:
          EmptyView()
        case .possible(let value):
          PullToRefreshContentView(color: .red,
                                   foregroundColor: .black,
                                   value: value)
          .frame(width: 40, height: 40)
          .padding()
        case .triggered, .waitingOnRefresh, .interactionOngoingRefreshComplete:
          ProgressView()
            .progressViewStyle(.circular)
            .padding()
        }
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
    try! await Task.sleep(nanoseconds: 1000000000)//3000000000)
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
