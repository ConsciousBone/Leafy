//
//  SettingsView.swift
//  Leafy
//
//  Created by Evan Plant on 21/10/2025.
//

import SwiftUI

struct SettingsView: View {
    // API stuff
    @AppStorage("apiURL") private var apiURL = "https://leafyapi.consciousb.one/v1/chat/completions"
    
    // Accent colour
    @AppStorage("selectedAccentIndex") private var selectedAccentIndex = 1 // orange
    let accentColours = [
        Color.red.gradient, Color.orange.gradient,
        Color.yellow.gradient, Color.green.gradient,
        Color.mint.gradient, Color.blue.gradient,
        Color.purple.gradient, Color.brown.gradient,
        Color.white.gradient, Color.black.gradient
    ]
    let accentColourNames = [
        "Red", "Orange",
        "Yellow", "Green",
        "Mint", "Blue",
        "Purple", "Brown",
        "White", "Black"
    ]
    
    var body: some View {
        Form {
            Section { // accent
                Picker(selection: $selectedAccentIndex) {
                    ForEach(accentColours.indices, id: \.self) { index in
                        Text(accentColourNames[index])
                    }
                } label: {
                    Label("Accent Colour", systemImage: "paintpalette")
                }
            }
            
            Section {
                TextField("API URL", text: $apiURL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
            } header: {
                Text("API URL")
            }
        }
    }
}

#Preview {
    SettingsView()
}
