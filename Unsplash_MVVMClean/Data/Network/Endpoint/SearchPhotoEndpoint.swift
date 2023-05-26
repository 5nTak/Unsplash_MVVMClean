//
//  SearchPhotoEndpoint.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/25.
//

import Foundation

struct SearchPhotoEndpoint: UnsplashAPIEndpoint {
    typealias APIResponse = SearchPhotoResponseDTO
    
    var pageNum: Int
    var searchText: String
    var path: String = "search/photos"
    var queries: [String : String] {
        return [
            "page": "\(pageNum)",
            "per_page": "30",
            "query": "\(searchText)",
            "client_id": "\(serviceKey)"
        ]
    }
}
