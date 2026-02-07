//
//  PostDetailViewModel.swift
//  PostListView
//
//  Created by Lurf on 2026/02/06.
//

import Observation

@Observable
@MainActor
final class PostDetailViewModel {
    let post: Post
    
    var comments = [PostComment]()
    var isLoading = false
    var errorMessage: String?
    
    private let service: PostServiceProtocol

    init(post: Post, service: PostServiceProtocol) {
        self.post = post
        self.service = service
    }
    
    func fetchComments() async {
        guard comments.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            comments = try await service.fetchComments(for: post.id)
        } catch {
            errorMessage = "コメントの読み込みに失敗しました"
        }
        
        isLoading = false
    }
}
