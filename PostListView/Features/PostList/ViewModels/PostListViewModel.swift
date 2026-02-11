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
    var allPosts = [Post]()
    var displayPosts = [Post]()
    
    var users = [User]()
    var selectedUser: User? = nil {
        didSet {
            filterPosts()
        }
    }
    
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    private let service: PostFetching & UserFetching
    
    init(service: PostFetching & UserFetching) {
        self.service = service
    }
    
    func fetch() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let postsTask = service.fetchPosts()
            async let usersTask = service.fetchUsers()
            
            let (fetchedPosts, fetchedUsers) = try await (postsTask, usersTask)
            
            allPosts = fetchedPosts
            users = fetchedUsers
            
            filterPosts()
        } catch {
            errorMessage = "データの取得に失敗しました"
        }
        
        isLoading = false
    }
}

private extension PostListViewModel {
    func filterPosts() {
        if let selectedUser {
            displayPosts = allPosts.filter {
                $0.userId == selectedUser.id
            }
        } else {
            displayPosts = allPosts
        }
    }
}
