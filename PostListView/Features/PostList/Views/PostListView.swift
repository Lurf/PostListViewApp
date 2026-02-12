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
    
    private let service: PostService
    
    init(service: PostService) {
        self.service = service
        _viewModel = State(initialValue: PostListViewModel(service: service))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !viewModel.users.isEmpty {
                    UserFilterView(
                        users: viewModel.users, 
                        selectedUser: viewModel.selectedUser
                    ) { user in
                        withAnimation { 
                            viewModel.selectedUser = user
                        }
                    }
                    .background(Color(.systemBackground))
                    Divider()
                }
                Group {
                    if viewModel.isLoading {
                        ProgressView("読み込み中...")
                            .frame(maxHeight: .infinity)
                    } else if let errorMessage = viewModel.errorMessage {
                        ContentUnavailableView(
                            "エラー",
                            systemImage: "exclamationmark.triangle",
                            description: Text(errorMessage)
                        )
                    } else {
                        List(viewModel.displayPosts) { post in
                            NavigationLink(value: post) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(post.title)
                                        .font(.headline)
                                    Text(post.body)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }   
                            }
                            .padding(.vertical, 4)
                        }
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
            .navigationDestination(for: Post.self) { post in
                PostDetailView(
                    viewModel: PostDetailViewModel(
                        post: post,
                        service: service
                    )
                )
            }
        }
    }
}

#Preview {
    PostListView(service: PostService())
}
