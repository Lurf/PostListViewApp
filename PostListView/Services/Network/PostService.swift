//
//  PostService.swift
//  PostListView
//
//  Created by Lurf on 2026/02/03.
//

import Foundation

private let postsURL = "https://jsonplaceholder.typicode.com/posts"
private let usersURL = "https://jsonplaceholder.typicode.com/users"


protocol PostFetching: Sendable {
    func fetchPosts() async throws -> [Post]
}

protocol CommentFetching: Sendable {
    func fetchComments(for postID: Int) async throws -> [PostComment]
}

protocol UserFetching: Sendable {
    func fetchUsers() async throws -> [User]
}

struct PostService: PostFetching, CommentFetching, UserFetching, Sendable {
    private let commentCache = CommentCache()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: postsURL) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            return try JSONDecoder().decode([Post].self, from: data)
        } catch _ as DecodingError {
            throw APIError.decodeError
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func fetchComments(for postID: Int) async throws -> [PostComment] {
        if let cache = await commentCache.get(for: postID) {
            print("🚀 Cache hit: Post \(postID)")
            return cache
        }
        
        print("🚀 API Request:: Post \(postID)")
        let urlString = "\(postsURL)/\(postID)/comments"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        let comments = try JSONDecoder().decode([PostComment].self, from: data)
        
        await commentCache.set(comments, for: postID)
        
        return comments
    }
    
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: usersURL) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }
}
