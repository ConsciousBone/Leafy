//
//  SettingsView.swift
//  Leafy
//
//  Created by Evan Plant on 21/10/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("apiURL") private var apiURL = "https://leafyapi.consciousb.one/v1/chat/completions"
    var body: some View {
        Form {
            Section {
                TextField("https://example.com/api", text: $apiURL, prompt: Text("API URL"))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.URL)
            } header: {
                Text("OpenRouter API URL")
            }
        }
    }
}

#Preview {
    SettingsView()
}
