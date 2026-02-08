//
//  PostComment.swift
//  PostListView
//
//  Created by Lurf on 2026/02/07.
//

import Foundation

struct PostComment: Codable, Identifiable, Sendable, Hashable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
