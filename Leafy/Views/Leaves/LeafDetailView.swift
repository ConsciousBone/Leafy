//
//  LeafDetailView.swift
//  Leafy
//
//  Created by Evan Plant on 26/10/2025.
//

import SwiftUI

private extension Image {
    init?(leafData data: Data) {
        guard let ui = UIImage(data: data) else { return nil }
        self = Image(uiImage: ui)
    }
}

struct LeafDetailView: View {
    let leafItem: LeafItem
    
    var body: some View {
        Form {
            Section {
                if let img = Image(leafData: leafItem.leafImageData) {
                    img
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else { // somehow no image
                    Image(systemName: "photo")
                }
            } header: {
                Text("Leaf Image")
            }
            
            Section {
                Text(leafItem.leafName)
            } header: {
                Text("Leaf Name")
            }
            
            Section {
                Text(leafItem.leafDescription)
            } header: {
                Text("Leaf Description")
            }
        }
        .navigationTitle(leafItem.leafName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
