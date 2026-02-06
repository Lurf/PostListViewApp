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
                Text(viewModel.post.title)
                    .font(.title)
                    .fontWeight(.bold)
                Divider()
                Text(viewModel.post.body)
                    .font(.body)
                    .lineSpacing(4)
            }
            .padding()
        }
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}
