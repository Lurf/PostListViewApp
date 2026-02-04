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
}
