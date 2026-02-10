//
//  CommentCache.swift
//  PostListView
//
//  Created by Lurf on 2026/02/10.
//

import Foundation

actor CommentCache: Sendable {
    private var cache = [Int: [PostComment]]()
    
    func get(for postID: Int) -> [PostComment]? {
        cache[postID]
    }
    
    func set(_ comments: [PostComment], for postID: Int) {
        cache[postID] = comments
    }
    
    func remove(for postID: Int) {
        cache[postID] = nil
    }
    
    func clear() {
        cache.removeAll()
    }
}
