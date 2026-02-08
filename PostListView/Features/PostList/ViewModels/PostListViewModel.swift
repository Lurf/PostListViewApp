//
//  PostListViewModel.swift
//  PostListView
//
//  Created by Lurf on 2026/02/03.
//

import Foundation
import Observation

@Observable
@MainActor
final class PostListViewModel {
    var posts = [Post]()
    var isLoading: Bool = false
    var errorMessage: String?
    
    private let service: PostFetching
    
    init(service: PostFetching) {
        self.service = service
    }
    
    func fetch() async {
        isLoading = true
        errorMessage = nil
        
        do {
            posts = try await service.fetchPosts()
        } catch {
            errorMessage = "データの取得に失敗しました"
        }
        
        isLoading = false
    }
}
