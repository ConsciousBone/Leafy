//
//  LeavesView.swift
//  Leafy
//
//  Created by Evan Plant on 21/10/2025.
//

import SwiftUI

struct LeavesView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("a")
                }
            }
            .navigationTitle("Leaves")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("adding new leaf")
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    LeavesView()
}
