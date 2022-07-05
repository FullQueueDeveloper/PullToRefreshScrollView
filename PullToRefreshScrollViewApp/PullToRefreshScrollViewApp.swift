//
//  PullToRefreshScrollViewApp.swift
//  PullToRefreshScrollView
//
//  Created by Full Queue Developer on 7/4/22.
//

import SwiftUI

@main
struct PullToRefreshScrollViewApp: App {
  var body: some Scene {
    WindowGroup {
//      NavigationView {
      GistContentView()
          .navigationTitle("Pull to refresh")
          .toolbar {
            Button {
              print("settings")
            } label: {
               Label("Settings", systemImage: "gear")
            }
          }
//      }
    }
  }
}
