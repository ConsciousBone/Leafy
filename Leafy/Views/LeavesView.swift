//
//  LeavesView.swift
//  Leafy
//
//  Created by Evan Plant on 21/10/2025.
//

import SwiftUI
import SwiftData

struct LeavesView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \LeafItem.leafDate, order: .reverse) var leafItems: [LeafItem]
    
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
