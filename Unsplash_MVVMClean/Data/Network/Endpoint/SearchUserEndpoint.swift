//
//  SearchUserEndpoint.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/25.
//

import Foundation

struct SearchUserEndpoint: UnsplashAPIEndpoint {
    typealias APIResponse = SearchUserResponseDTO
    
    var pageNum: Int
    var searchText: String
    var path: String = "search/users"
    var queries: [String : String] {
        return [
            "page": "\(pageNum)",
            "per_page": "30",
            "query": "\(searchText)",
            "client_id": "\(serviceKey)"
        ]
    }
}
