//
//  PostService.swift
//  PostListView
//
//  Created by Lurf on 2026/02/03.
//

import Foundation

private let baseURL = "https://jsonplaceholder.typicode.com/posts"

protocol PostServiceProtocol: Sendable {
    func fetchPosts() async throws -> [Post]
}

struct PostService: PostServiceProtocol {
    init() {}
    
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Post].self, from: data)
        } catch _ as DecodingError {
            throw APIError.decodeError
        } catch {
            throw APIError.networkError(error)
        }
    }
}
