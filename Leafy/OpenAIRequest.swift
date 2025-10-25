//
//  OpenAIRequest.swift
//  Leafy
//
//  Created by Evan Plant on 25/10/2025.
//

import Foundation
import UIKit

let proxySecret: String = {
    guard let url = Bundle.main.url(forResource: "proxysecret", withExtension: "txt"),
          let data = try? Data(contentsOf: url),
          let s = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
          !s.isEmpty else {
        fatalError("proxysecret.txt missing or empty")
    }
    return s
}()

struct ChatResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

private struct ChatRequest: Encodable {
    let model: String
    let messages: [Message]
    
    struct Message: Encodable {
        let role: String
        let content: [Content]
    }
    struct Content: Encodable {
        let type: String
        let text: String?
        let image_url: ImageURL?
        
        struct ImageURL: Encodable {
            let url: String
            let detail: String?
        }
    }
}

func cleanAIJSON(_ text: String) -> String {
    text
        .replacingOccurrences(of: "```json", with: "")
        .replacingOccurrences(of: "```", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

func sendImageToAI(
    image: UIImage,
    prompt: String,
    completion: @escaping (Result<String, Error>) -> Void
) {
    guard let imageData = image.jpegData(compressionQuality: 0.7) else {
        completion(.failure(NSError(domain: "Leafy", code: 1, userInfo: [NSLocalizedDescriptionKey: "could not make jpeg"])))
        return
    }
    let dataURL = "data:image/jpeg;base64,\(imageData.base64EncodedString())"
    
    let reqBody = ChatRequest(
        model: "gpt-4o-mini",
        messages: [
            .init(
                role: "user",
                content: [
                    .init(type: "image_url",
                          text: nil,
                          image_url: .init(url: dataURL, detail: "low")),
                    .init(type: "text",
                          text: prompt,
                          image_url: nil)
                ]
            )
        ]
    )
    
    let encoder = JSONEncoder()
    guard let json = try? encoder.encode(reqBody) else {
        completion(.failure(NSError(domain: "Leafy", code: 2, userInfo: [NSLocalizedDescriptionKey: "json encoding failed"])))
        return
    }
    
    var req = URLRequest(url: URL(string: "https://leafyapi.consciousb.one/v1/chat/completions")!)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.setValue(proxySecret, forHTTPHeaderField: "X-Proxy-Secret")
    req.httpBody = json
    req.timeoutInterval = 120
    
    URLSession.shared.dataTask(with: req) { data, resp, err in
        func finish(_ result: Result<String, Error>) {
            DispatchQueue.main.async { completion(result) }
        }
        
        if let err = err { return finish(.failure(err)) }
        guard let http = resp as? HTTPURLResponse else {
            return finish(.failure(NSError(domain: "Leafy", code: 3, userInfo: [NSLocalizedDescriptionKey: "no http response"])))
        }
        guard (200..<300).contains(http.statusCode) else {
            let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? "<no body>"
            return finish(.failure(NSError(domain: "Leafy", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode): \(body)"])))
        }
        guard let data = data else {
            return finish(.failure(NSError(domain: "Leafy", code: 4, userInfo: [NSLocalizedDescriptionKey: "empty body"])))
        }
        
        do {
            let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
            let text = decoded.choices.first?.message.content ?? ""
            let cleaned = cleanAIJSON(text)
            finish(.success(cleaned))
        } catch {
            let raw = String(data: data, encoding: .utf8) ?? "<non-utf8 body>"
            finish(.failure(NSError(domain: "Leafy", code: 5, userInfo: [NSLocalizedDescriptionKey: "decode failed, raw:\n\(raw)"])))
        }
    }.resume()
}
