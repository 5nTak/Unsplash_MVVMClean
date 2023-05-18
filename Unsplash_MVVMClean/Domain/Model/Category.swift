//
//  Category.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

struct Category {
    let id: String
    let title: String
    let coverPhoto: CoverPhoto
    
    struct CoverPhoto {
        let urls: ImageURLStyle
    }
}
