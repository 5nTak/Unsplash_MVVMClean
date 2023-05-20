//
//  FetchType.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/20.
//

import Foundation


enum FetchType {
    case photo
    case category
    case search(type: SearchType)
    
    var description: String {
        switch self {
        case .photo:
            return "/photos"
        case .category:
            return "/topics"
        case .search(let type):
            return "/search/\(type.rawValue)"
        }
    }
}

enum SearchType: String, CaseIterable {
    case photo = "photos"
    case collection = "collections"
    case user = "users"
}

extension SearchType {
    init?(index: Int) {
        switch index {
        case 0:
            self = .photo
        case 1:
            self = .collection
        default:
            self = .user
        }
    }
}
