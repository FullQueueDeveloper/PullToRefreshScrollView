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
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
