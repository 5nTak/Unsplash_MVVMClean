//
//  Collection.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

struct Collection: Searchable, Equatable {
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        return lhs.id == rhs.id
        && lhs.title == rhs.title
        && lhs.description == rhs.description
        && lhs.totalPhotos == rhs.totalPhotos
        && lhs.previewPhotos == rhs.previewPhotos
        && lhs.user == rhs.user
    }
    
    let id: String
    let title: String
    let description: String?
    let totalPhotos: Int
    let previewPhotos: [PreviewPhoto]
    let user: User
    
    struct PreviewPhoto: Equatable {
        let id: String
        let urls: ImageURLStyle
    }
}
