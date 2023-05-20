//
//  Collection.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

struct Collection: Identifiable {
    let id: String
    let title: String
    let description: String?
    let totalPhotos: Int
    let previewPhotos: [PreviewPhotos]
    let user: User
    
    struct PreviewPhotos {
        let identifier: String
        let urls: ImageURLStyle
    }
}
