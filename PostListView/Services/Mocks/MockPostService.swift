//
//  MockPostService.swift
//  PostListView
//
//  Created by Lurf on 2026/02/04.
//

#if DEBUG
import Foundation


struct MockPostService: PostFetching, CommentFetching, UserFetching, Sendable {
    let postsResult: Result<[Post], Error>
    let commentsResult: Result<[PostComment], Error>
    let userResult: Result<[User], Error>
    
    init(
        postsResult: Result<[Post], Error> = .success([]),
        commentsResult: Result<[PostComment], Error> = .success([]),
        userResult: Result<[User], Error> = .success([])
    ) {
        self.postsResult = postsResult
        self.commentsResult = commentsResult
        self.userResult = userResult
    }
    
    init(
        posts: [Post] = [], 
        comments: [PostComment] = [], 
        users: [User] = []
    ) {
        self.postsResult = .success(posts)
        self.commentsResult = .success(comments)
        self.userResult = .success(users)
    }

    func fetchPosts() async throws -> [Post] {
        try await Task.sleep(for: .seconds(0.1))
        
        switch postsResult {
        case .success(let posts):
            return posts
        case .failure(let error):
            throw error
        }
    }
    
    func fetchComments(for postID: Int) async throws -> [PostComment] {
        try await Task.sleep(for: .seconds(0.1))
        
        switch commentsResult {
        case .success(let comments):
            return comments
        case .failure(let error):
            throw error
        }
    }
    
    func fetchUsers() async throws -> [User] {
        switch userResult {
        case .success(let users):
            return users
        case .failure(let error):
            throw error
        }
    }
}

extension MockPostService {
    static let sampleData = [
        Post(userId: 1, id: 1, title: "テスト投稿1", body: "これはテストです。"),
        Post(userId: 2, id: 2, title: "テスト投稿2", body: "Mockデータを利用しています。")
    ]
    
    static let success = MockPostService(posts: sampleData)
    static let failure = MockPostService(postsResult: .failure(APIError.decodeError))
}

#endif
