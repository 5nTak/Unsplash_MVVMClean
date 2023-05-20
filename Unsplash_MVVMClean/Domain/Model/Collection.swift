//
//  Collection.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

struct Collection: Searchable {
    let id: String
    let title: String
    let description: String?
    let totalPhotos: Int
    let previewPhotos: [PreviewPhoto]
    let user: User
    
    struct PreviewPhoto {
        let id: String
        let urls: ImageURLStyle
    }
}
