//
//  PostListViewApp.swift
//  PostListView
//
//  Created by Lurf on 2026/02/03.
//

import SwiftUI

@main
struct PostListViewApp: App {
    var body: some Scene {
        WindowGroup {
            PostListView(viewModel: PostListViewModel(service: PostService()))
        }
    }
}
