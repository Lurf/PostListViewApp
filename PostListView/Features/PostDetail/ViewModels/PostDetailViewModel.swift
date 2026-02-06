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
    
    init(post: Post) {
        self.post = post
    }
}
