//
//  LeavesView.swift
//  Leafy
//
//  Created by Evan Plant on 21/10/2025.
//

import SwiftUI
import UIKit
import SwiftData

private extension Image {
    init?(leafData data: Data) {
        guard let ui = UIImage(data: data) else { return nil }
        self = Image(uiImage: ui)
    }
}

struct LeavesView: View {
    @Environment(\.modelContext) var modelContext
    @State private var leafPath = [LeafItem]()
    @Query(sort: \LeafItem.leafDate, order: .reverse) var leafItems: [LeafItem]
    
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            if leafItems.count == 0 {
                ContentUnavailableView {
                    Label("No leaves", systemImage: "leaf")
                } description: {
                    Text("You haven't saved any leaves yet.")
                } actions: {
                    Button {
                        print("adding new leaf")
                        showingAddSheet.toggle()
                    } label: {
                        Label("Add leaf", systemImage: "plus")
                    }
                    .buttonStyle(.bordered)
                }
                .navigationTitle("Leaves")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingAddSheet) {
                    LeafAddView()
                        .presentationDetents([.fraction(0.75), .large])
                }
            } else {
                Form {
                    ForEach(leafItems) { leaf in
                        Section {
                            HStack {
                                if let img = Image(leafData: leaf.leafImageData) {
                                    img
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else { // if theres somehow no image
                                    Image(systemName: "photo")
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(leaf.leafName)
                                        .multilineTextAlignment(.leading)
                                    Text(leaf.leafDescription)
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        withAnimation {
                            indexSet.map{leafItems[$0]}.forEach(modelContext.delete)
                        }
                    }
                }
                .navigationTitle("Leaves")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            print("adding new leaf")
                            showingAddSheet.toggle()
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    LeafAddView()
                        .presentationDetents([.fraction(0.75)])
                }
            }
        }
    }
}

#Preview {
    LeavesView()
}
