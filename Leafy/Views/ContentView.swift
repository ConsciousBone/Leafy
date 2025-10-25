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
            //Tab("Home", systemImage: "house") {
            //    HomeView()
            //}
            Tab("Leaves", systemImage: "leaf") {
                LeavesView()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
            //Tab("Test", systemImage: "") {
            //    LeafyTestView()
            //}
        }
    }
}

#Preview {
    ContentView()
}
