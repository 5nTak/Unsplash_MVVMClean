//
//  CategoryEndpoint.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/25.
//

import Foundation

struct CategoryEndpoint: UnsplashAPIEndpoint {
    typealias APIResponse = CategoryResponse
    
    var path: String = "/topics"
    var queries: [String : String] {
        return [
            "client_id": "\(serviceKey)"
        ]
    }
}
