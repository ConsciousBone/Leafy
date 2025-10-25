//
//  LeafItem.swift
//  Leafy
//
//  Created by Evan Plant on 25/10/2025.
//

import Foundation
import SwiftData

@Model class LeafItem {
    var leafName: String // name of the leaf, ai generated
    var leafDescription: String // description of the leaf, also ai generated
    // some random reddit comment said this is a good way to
    // store images in swiftdata so im doing it this way
    @Attribute(.externalStorage) var leafImageData: Data
    var leafDate: Date // sorting stuff, also nice to have
    var id = UUID() // good practice ig
    
    init(
        leafName: String = "",
        leafDescription: String = "",
        leafImageData: Data,
        leafDate: Date = .now,
        id: UUID = UUID()
    ){
        self.leafName = leafName
        self.leafDescription = leafDescription
        self.leafImageData = leafImageData
        self.leafDate = leafDate
        self.id = id
    }
}
