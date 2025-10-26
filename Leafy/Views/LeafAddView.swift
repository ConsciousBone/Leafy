//
//  LeafAddView.swift
//  Leafy
//
//  Created by Evan Plant on 26/10/2025.
//

import SwiftUI

// ai structs n stuffs
private struct LeafInfo: Decodable {
    let name: String
    let description: String
}
private func decodeLeafInfo(from text: String) -> LeafInfo? {
    let cleaned = cleanAIJSON(text)
    guard let data = cleaned.data(using: .utf8) else { return nil }
    return try? JSONDecoder().decode(LeafInfo.self, from: data)
}

struct LeafAddView: View {
    var body: some View {
        Form {
            
        }
    }
}

#Preview {
    LeafAddView()
}
