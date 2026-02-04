//
//  MockPostService.swift
//  PostListView
//
//  Created by Lurf on 2026/02/04.
//

import Foundation

#if DEBUG

struct MockPostService: PostServiceProtocol, Sendable {
    let result: Result<[Post], Error>
    
    init(result: Result<[Post], Error> = .success([])) {
        self.result = result
    }
    
    init(posts: [Post]) {
        self.result = .success(posts)
    }

    func fetchPosts() async throws -> [Post] {
        try await Task.sleep(for: .seconds(0.5))
        
        switch result {
        case .success(let posts):
            return posts
        case .failure(let error):
            throw error
        }
    }
}

extension MockPostService {
    static let sampleData = [
        Post(id: 1, title: "テスト投稿1", body: "これはテストです。"),
        Post(id: 2, title: "テスト投稿2", body: "Mockデータを利用しています。")
    ]
    
    static let success = MockPostService(posts: sampleData)
    static let failure = MockPostService(result: .failure(APIError.decodeError))
}

#endif
