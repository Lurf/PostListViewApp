//
//  PostDetailView.swift
//  PostListView
//
//  Created by Lurf on 2026/02/06.
//

import SwiftUI

struct PostDetailView: View {
    let viewModel: PostDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                postContentSection
                Divider()
                commentsSection
            }
            .padding()
        }
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchComments()
        }
    }
    
    private var postContentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.post.title)
                .font(.title)
                .fontWeight(.bold)
            Text(viewModel.post.body)
                .font(.body)
                .lineSpacing(4)
        }
    }
    
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("コメント")
                .font(.headline)
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
            } else {
                ForEach(viewModel.comments) { comment in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(comment.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(comment.body)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    Divider()
                }
            }
        }
    }
}
