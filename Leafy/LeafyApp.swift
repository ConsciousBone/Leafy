//
//  LeafyApp.swift
//  Leafy
//
//  Created by Evan Plant on 21/10/2025.
//

import SwiftUI
import SwiftData

@main
struct LeafyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [LeafItem.self]) // swiftdataaaa
    }
}
