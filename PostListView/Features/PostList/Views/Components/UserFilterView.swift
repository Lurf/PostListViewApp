//
//  UserFilterView.swift
//  PostListView
//
//  Created by Lurf on 2026/02/11.
//

import SwiftUI

struct UserFilterView: View {
    let users: [User]
    let selectedUser: User?
    let onSelect: (User?) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    label: "All", 
                    isSelected: selectedUser == nil) {
                        onSelect(nil)
                    }
                ForEach(users) { user in
                    FilterChip(
                        label: user.username, 
                        isSelected: selectedUser?.id == user.id
                    ) { 
                        onSelect(user)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? .blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
                .animation(.snappy, value: isSelected)
        }
    }
}
