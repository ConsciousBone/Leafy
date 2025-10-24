//
//  OpenAIClient.swift
//  Leafy
//
//  Created by Evan Plant on 24/10/2025.
//

import Foundation
import OpenAI

let proxySecret: String = {
    guard let url = Bundle.main.url(forResource: "proxysecret", withExtension: "txt"),
          let data = try? Data(contentsOf: url),
          let s = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
          !s.isEmpty else {
        fatalError("proxysecret.txt is either missing or empty, fix pls!")
    }
    return s
}()
