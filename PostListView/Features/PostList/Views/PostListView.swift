//
//  ContentView.swift
//  PostListView
//
//  Created by Lurf on 2026/02/03.
//

import SwiftUI

@MainActor
struct PostListView: View {
    @State private var viewModel: PostListViewModel
    
    init(viewModel: PostListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("読み込み中...")
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(
                        "エラー",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage)
                    )
                } else {
                    List(viewModel.posts) { post in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.body)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("最新の投稿")
            .task {
                await viewModel.fetch()
            }
            .refreshable {
                await viewModel.fetch()
            }
        }
    }
}

#Preview {
    PostListView(
        viewModel: PostListViewModel(
            service: MockPostService(
                posts: MockPostService.sampleData
            )
        )
    )
}
