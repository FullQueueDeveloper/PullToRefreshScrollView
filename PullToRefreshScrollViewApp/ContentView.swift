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
    PullToRefreshScrollView {
      print("sleeping")
      try! await Task.sleep(nanoseconds: 5000000000)
      await MainActor.run {
        items = [
          UUID(),
          UUID(),
          UUID(),
          UUID(),
          UUID(),
        ]
      }
      print("done sleeping")
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
