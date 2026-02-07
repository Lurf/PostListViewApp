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
    func fetchComments(for postID: Int) async throws -> [PostComment]
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
    
    func fetchComments(for postID: Int) async throws -> [PostComment] {
        let urlString = "\(baseURL)/\(postID)/comments"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([PostComment].self, from: data)
    }
}
