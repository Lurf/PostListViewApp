//
//  APIError.swift
//  PostListView
//
//  Created by Lurf on 2026/02/03.
//

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodeError
}
