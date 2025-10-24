//
//  Functions.swift
//  Leafy
//
//  Created by Evan Plant on 23/10/2025.
//

import Foundation

struct LeafResult: Codable {
    let name: String
    let description: String
}

func sendLeafRequestAI(b64image: String, apiURL: String) async throws -> LeafResult {
    // forwards openrouter api requests to my server before
    // actually going to openrouter, no api key here!
    guard let secretURL = Bundle.main.url(forResource: "proxysecret", withExtension: "txt"),
          let proxySecret = try? String(contentsOf: secretURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines),
          !proxySecret.isEmpty else {
        throw NSError(domain: "LeafyProxy", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing proxysecret.txt or it's empty"])
    }
    
    let dataURL = "data:image/jpeg;base64,\(b64image)"
    let messages: [[String: Any]] = [
        [
            "role": "user",
            "content": [
                ["type": "text",
                 "text": "What leaf is this? Reply ONLY as compact JSON with these fields: name, description."],
                ["type": "image_url",
                 "image_url": ["url": dataURL]]
            ]
        ]
    ]
    let payload: [String: Any] = [
        "model": "qwen/qwen3-vl-32b-instruct", // its cheap and works with vision, good for me ig
        "messages": messages,
        "temperature": 0.2
    ]
    
    let url = URL(string: apiURL)!
    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.addValue("application/json", forHTTPHeaderField: "Content-Type")
    req.addValue(proxySecret, forHTTPHeaderField: "X-Proxy-Secret")
    req.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
    
    let (data, resp) = try await URLSession.shared.data(for: req)
    guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
        let body = String(data: data, encoding: .utf8) ?? "(no body)"
        throw NSError(
            domain: "LeafyProxy",
            code: 2,
            userInfo: [
                NSLocalizedDescriptionKey: "bad status: \((resp as? HTTPURLResponse)?.statusCode ?? -1); body: \(body)"
            ]
        )
    }
    
    struct ORMessage: Codable { let content: String }
    struct ORChoice: Codable { let message: ORMessage }
    struct ORRoot: Codable { let choices: [ORChoice] }
    
    let decoded = try JSONDecoder().decode(ORRoot.self, from: data)
    guard let content = decoded.choices.first?.message.content.data(using: .utf8) else {
        throw NSError(
            domain: "LeafyProxy",
            code: 3,
            userInfo: [
                NSLocalizedDescriptionKey: "no content in response"
            ]
        )
    }
    
    return try JSONDecoder().decode(LeafResult.self, from: content)
}
