//
//  Post.swift
//  PostListView
//
//  Created by Lurf on 2026/02/03.
//

import Foundation

/// https://jsonplaceholder.typicode.com/posts
struct Post: Codable, Identifiable, Sendable, Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
