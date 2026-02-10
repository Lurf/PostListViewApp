//
//  PostServiceTests.swift
//  PostListView
//
//  Created by Lurf on 2026/02/10.
//

import Testing
import Foundation
@testable import PostListView

@Suite("PosetService Cache Logic Tests")
struct PostServiceTests {
    let dummyComments = [
        PostComment(id: 1, postId: 1, name: "Test", email: "test@test.com", body: "Hello")
    ]
    
    func makeJSONData(from comments: [PostComment]) -> Data {
        return try! JSONEncoder().encode(comments)
    }
    
    @Test("キャッシュロジック: 2回目の取得でAPIリクエストが発生しない")
    func verifyCacheHit() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil,headerFields: nil)!
            return (response, makeJSONData(from: self.dummyComments))
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        
        let service = await PostService(session: mockSession)
        
        
        var requestCount = 0
        MockURLProtocol.requestHandler = { request in
            requestCount += 1
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, makeJSONData(from: self.dummyComments))
        }
        
        let result1 = try await service.fetchComments(for: 1)
        #expect(result1.count == 1)
        #expect(requestCount == 1, "初回はAPIリクエストを行う")
        
        let result2 = try await service.fetchComments(for: 1)
        #expect(result2.count == 1)
        #expect(requestCount == 1, "キャッシュ利用でリクエスト数は増えない")
        
        _ = try await service.fetchComments(for: 999)
        #expect(requestCount == 2, "別のIDならAPIリクエストを行う")
    }
}
