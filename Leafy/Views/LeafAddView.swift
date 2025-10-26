//
//  LeafAddView.swift
//  Leafy
//
//  Created by Evan Plant on 26/10/2025.
//

import SwiftUI
import SwiftData
import UIKit

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
    @Environment(\.modelContext) private var modelContext
    @State private var leafPath = [LeafItem]()
    @Environment(\.presentationMode) var presentationMode // lets us dismiss the sheet
    
    @State private var showingCamera = false
    
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var errorText = ""
    
    @State private var aiName = ""
    @State private var aiDescription = ""
    
    // get ai to actually just give json with a decent prompt
    private let prompt = """
        Respond ONLY with compact JSON: {"name":"", "description":""}
        No markdown. No code fences. No extra text.
        """
    
    // fancy func logical stuffs
    private func analyse() {
        guard let img = image else { return }
        isLoading = true
        errorText = ""
        aiName = ""
        aiDescription = ""
        
        sendImageToAI(image: img, prompt: prompt) { result in
            isLoading = false
            switch result {
            case .success(let raw):
                if let info = decodeLeafInfo(from: raw) {
                    aiName = info.name
                    aiDescription = info.description
                } else {
                    errorText = "ai returned something that isn't json:\n\(raw)"
                }
            case .failure(let err):
                errorText = err.localizedDescription
            }
        }
    }
    
    private func saveLeaf() {
        guard let img = image,
              let data = img.jpegData(compressionQuality: 0.85) else {
            errorText = "image is missing or couldn't encode"
            return
        }
        let leafItem = LeafItem(
            leafName: aiName,
            leafDescription: aiDescription,
            leafImageData: data,
            leafDate: .now
        )
        modelContext.insert(leafItem)
        leafPath = [leafItem]
        print("leaf saved")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section { // photo
                    if let img = image {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Button {
                            showingCamera = true
                        } label: {
                            Label("Retake photo", systemImage: "camera")
                        }
                    } else {
                        Text("No image")
                        
                        Button {
                            showingCamera = true
                        } label: {
                            Label("Take photo", systemImage: "camera")
                        }
                    }
                }
                
                Section {
                    Button {
                        analyse()
                    } label: {
                        if isLoading {
                            ProgressView()
                        } else {
                            Label("Get leaf data", systemImage: "brain")
                        }
                    }
                    .disabled(image == nil || isLoading)
                    
                    if !errorText.isEmpty { // is error erroring
                        Text(errorText)
                    }
                }
                
                Section { // name, ai provided
                    Text(aiName.isEmpty ? "???" : aiName)
                }
                
                Section { // description, ai provided
                    Text(aiDescription.isEmpty ? "???" : aiDescription)
                }
                
                Section {
                    Button {
                        saveLeaf()
                        presentationMode.wrappedValue.dismiss() // close sheet
                    } label: {
                        Label("Save leaf", systemImage: "checkmark")
                    }
                    .disabled(image == nil || aiName.isEmpty || aiDescription.isEmpty)
                }
            }
            .navigationTitle("Add leaf")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark")
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(source: .camera) {
                    img in image = img
                }
            }
        }
    }
}

#Preview {
    LeafAddView()
}
