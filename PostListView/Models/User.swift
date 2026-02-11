//
//  User.swift
//  PostListView
//
//  Created by Lurf on 2026/02/11.
//

/// https://jsonplaceholder.typicode.com/users
struct User: Codable, Identifiable, Sendable, Hashable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
