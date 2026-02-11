//
//  PostDetailViewModelTests.swift
//  PostListView
//
//  Created by Lurf on 2026/02/07.
//

import Testing
import Foundation
@testable import PostListView

@Suite("PostDetailViewModelのテスト")
@MainActor
struct PostDetailViewModelTests {
    let testPost = Post(userId:1, id: 1, title: "Test Post", body: "Body")
    let testCommets = [
        PostComment(id: 1, postId: 1, name: "User1", email: "user1@user.com", body: "Nice post!"),
        PostComment(id: 2, postId: 1, name: "User2", email: "user2@user.com", body: "Good one!")
    ]
    
    @Test("正常系: コメントの取得に成功した場合、プロパティを更新する")
    func fetchCommentsSuccess() async {
        let mockService = MockPostService(comments: testCommets)
        let viewModel = PostDetailViewModel(post: testPost, service: mockService)
        
        #expect(viewModel.comments.isEmpty)
        
        await viewModel.fetchComments()
        
        #expect(viewModel.comments.count == 2)
        #expect(viewModel.comments.first?.body == "Nice post!")
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("異常系: コメントの取得に失敗した場合、エラーメッセージを表示する")
    func fetchCommentsFailure() async {
        let mockService = MockPostService(
            commentsResult: .failure(
                APIError.networkError(NSError(domain: "", code: -1))
            )
        )
        let viewModel = PostDetailViewModel(post: testPost, service: mockService)
        
        await viewModel.fetchComments()
        
        #expect(viewModel.comments.isEmpty)
        #expect(viewModel.errorMessage == "コメントの読み込みに失敗しました")
        #expect(!viewModel.isLoading)
    }
    
    @Test("重複防止: すでにコメントがある場合、再取得しない")
    func avoidDuplicateFetch() async {
        let mockService = MockPostService(comments: [])
        let viewModel = PostDetailViewModel(post: testPost, service: mockService)
        
        viewModel.comments = testCommets 
        
        await viewModel.fetchComments()
        
        #expect(viewModel.comments.count == 2)
    }
}
