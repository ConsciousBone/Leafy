//
//  ContentView.swift
//  Leafy
//
//  Created by Evan Plant on 21/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Leaves", systemImage: "leaf") {
                LeavesView()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
        .tint(.orange)
    }
}

#Preview {
    ContentView()
}
