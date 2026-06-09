//
//  CollegeAPIService.swift
//  collide
//
//  Created by Antigravity on 09/06/26.
//

import Foundation

struct CollegeResult: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let city: String
    let state: String
}

struct CollegeSearchResponse: Codable {
    let results: [CollegeResult]
    let query: String
}

class CollegeAPIService {
    static let shared = CollegeAPIService()
    
    private let apiKey = "cdb_46e9b6ca4e2ace23b4d6a4c1d282466e44bfb518a9815974"
    private let baseURL = "https://api.collegedb.in"
    
    private init() {}
    
    func searchColleges(query: String) async throws -> [CollegeResult] {
        guard query.count >= 2 else {
            return []
        }
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/v1/colleges/search?q=\(encodedQuery)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorMessage = errorJson["error"] as? String {
                throw NSError(domain: "CollegeAPIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            throw URLError(.init(rawValue: httpResponse.statusCode))
        }
        
        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode(CollegeSearchResponse.self, from: data)
        return searchResponse.results
    }
}
