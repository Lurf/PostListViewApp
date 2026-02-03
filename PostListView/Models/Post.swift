//
//  Post.swift
//  PostListView
//
//  Created by Lurf on 2026/02/03.
//

import Foundation

struct Post: Codable, Identifiable, Sendable {
    let id: Int
    let title: String
    let body: String
}
