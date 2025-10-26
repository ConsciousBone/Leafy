//
//  ContentView.swift
//  Leafy
//
//  Created by Evan Plant on 21/10/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedAccentIndex") private var selectedAccentIndex = 1 // orange
    let accentColours = [
        Color.red.gradient, Color.orange.gradient,
        Color.yellow.gradient, Color.green.gradient,
        Color.mint.gradient, Color.blue.gradient,
        Color.purple.gradient, Color.brown.gradient,
        Color.white.gradient, Color.black.gradient
    ]
    
    var body: some View {
        TabView {
            Tab("Leaves", systemImage: "leaf") {
                LeavesView()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
        .tint(accentColours[selectedAccentIndex])
    }
}

#Preview {
    ContentView()
}
