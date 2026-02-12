//
//  PostListViewModelTests.swift
//  PostListView
//
//  Created by Lurf on 2026/02/04.
//

import Testing
import Foundation
@testable import PostListView

@Suite("PostListViewModel Test")
@MainActor
struct PostListViewModelTests {
    @Test("正常系: APIからデータを取得し、リストに反映する")
    func fetchPostsSuccess() async throws {
        let expectedPosts = [
            Post(userId: 1, id: 1, title: "Test Title 1", body: "Body 1"),
            Post(userId: 2, id: 2, title: "Test Title 2", body: "Body 2"),
        ]
        
        let mockService = MockPostService(posts: expectedPosts)
        let viewModel = PostListViewModel(service: mockService)
        
        #expect(viewModel.allPosts.isEmpty)
        #expect(!viewModel.isLoading)
        
        await viewModel.fetch()
        
        #expect(viewModel.allPosts.count == 2)
        #expect(viewModel.allPosts.first?.title == "Test Title 1")
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("異常系: 通信エラーが発生した場合、エラーメッセージをセットする")
    func fetchPostsFailure() async {
        let mockService = MockPostService(postsResult: .failure(APIError.decodeError))
        let viewModel = PostListViewModel(service: mockService)
        
        await viewModel.fetch()
        
        #expect(viewModel.allPosts.isEmpty) // fetchに失敗し空のままかどうか
        
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage == "データの取得に失敗しました")
        
        #expect(!viewModel.isLoading)
    }
    
    @Test("ローディング状態: fetch実行中は確実にisLoadingがtrueになっていること")
    func checkLoadingStateDuringFetch() async {
        let (stream, continuation) = AsyncStream<Void>.makeStream()
        
        struct PausableMock: PostFetching, UserFetching {            
            let stream: AsyncStream<Void>
            
            func fetchPosts() async throws -> [Post] {
                // streamがfinishされるまでここで待機し続ける
                for await _ in stream { break }
                return []
            }
            
            func fetchUsers() async throws -> [User] {
                []
            }
        }
        
        let viewModel = PostListViewModel(service: PausableMock(stream: stream))
        
        #expect(!viewModel.isLoading)
        
        // fetchをメインスレッドの別タスクとして開始することでテストと並行してfetchが動く
        let fetchTask = Task {
            await viewModel.fetch()
        }
        
        try? await Task.sleep(for: .milliseconds(5))
        
        #expect(viewModel.isLoading)
        
        continuation.finish()
        
        _ = await fetchTask.result
        
        #expect(!viewModel.isLoading)
    }
    
    @Test("投稿とユーザー一覧が同時に取得される")
    func fetchPostsAndUsers() async throws {
        let mockPosts = [
            Post(userId: 1, id: 1, title: "Title", body: "Body")
        ]
        let mockUsers = [
            User(id: 1, name: "Alice", username: "alice", email: "a@a.com")
        ]
        
        let mockService = MockPostService(posts: mockPosts, users: mockUsers)
        let viewModel = PostListViewModel(service: mockService)
        
        await viewModel.fetch()
        
        #expect(viewModel.users.count == 1)
        #expect(viewModel.users.first?.name == "Alice")
        #expect(viewModel.displayPosts.count == 1)
    }
    
    @Test("ユーザーを選択した場合、そのユーザーの投稿のみ表示する")
    func filterPostsByUser() async {
        let user1 = User(id: 1, name: "Alice", username: "alice", email: "a@a.com")
        let user2 = User(id: 2, name: "Bob", username: "bob", email: "b@b.com")
        
        let posts = [
            Post(userId: 1, id: 101, title: "Alice's Post 1", body: "Hi."),
            Post(userId: 2, id: 102, title: "Bob's Post 1", body: "Hello."),
            Post(userId: 1, id: 103, title: "Alice's Post 2", body: "How are you?")
        ]
        
        let mockService = MockPostService(posts: posts, users: [user1, user2])
        let viewModel = PostListViewModel(service: mockService)
        
        await viewModel.fetch()
        #expect(viewModel.displayPosts.count == 3)
        
        viewModel.selectedUser = user1 // user1をタップ
        
        #expect(viewModel.displayPosts.count == 2)
        #expect(viewModel.displayPosts.allSatisfy{ $0.userId == 1 })
        
        viewModel.selectedUser = nil
        #expect(viewModel.displayPosts.count == 3)
    }
    
    @Test("投稿を持たないユーザーを選択した時、リストが空になること")
    func filterPostsByEmptyUser() async {
        let user1 = User(id: 1, name: "Alice", username: "alice", email: "a@a.com")
        let posts = [Post(userId: 2, id: 101, title: "Other's Post", body: "Hi")]
        
        let mockService = MockPostService(posts: posts, users: [user1])
        let viewModel = PostListViewModel(service: mockService)
        await viewModel.fetch()
        
        viewModel.selectedUser = user1
        
        #expect(viewModel.displayPosts.isEmpty)
    }
}
