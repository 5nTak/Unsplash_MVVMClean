//
//  PhotoListEndpoint.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/20.
//

import Foundation

struct PhotoListEndpoint: UnsplashAPIEndpoint {
    typealias APIResponse = [PhotoResponse] 
    
    var pageNum: Int
    var path: String = "/photos"
    var queries: [String : String] {
        return [
            "page": "\(pageNum)",
            "per_page": "30",
            "client_id": "\(serviceKey)"
        ]
    }
}
