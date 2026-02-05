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
            Post(id: 1, title: "Test Title 1", body: "Body 1"),
            Post(id: 2, title: "Test Title 2", body: "Body 2"),
        ]

        let mockService = MockPostService(posts: expectedPosts)
        let viewModel = PostListViewModel(service: mockService)

        #expect(viewModel.posts.isEmpty)
        #expect(!viewModel.isLoading)

        await viewModel.fetch()

        #expect(viewModel.posts.count == 2)
        #expect(viewModel.posts.first?.title == "Test Title 1")

        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("異常系: 通信エラーが発生した場合、エラーメッセージをセットする")
    func fetchPostsFailure() async {
        let mockService = MockPostService(result: .failure(APIError.decodeError))
        let viewModel = PostListViewModel(service: mockService)

        await viewModel.fetch()

        #expect(viewModel.posts.isEmpty) // fetchに失敗し空のままかどうか

        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage == "データの取得に失敗しました")

        #expect(!viewModel.isLoading)
    }
    
    @Test("ローディング状態: fetch実行中は確実にisLoadingがtrueになっていること")
    func checkLoadingStateDuringFetch() async {
        let (stream, continuation) = AsyncStream<Void>.makeStream()

        struct PausableMock: PostServiceProtocol {
            let stream: AsyncStream<Void>

            func fetchPosts() async throws -> [Post] {
                // streamがfinishされるまでここで待機し続ける
                for await _ in stream { break }
                return []
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
}
