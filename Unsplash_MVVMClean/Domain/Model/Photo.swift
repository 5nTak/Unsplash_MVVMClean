//
//  Photo.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

struct Photo: Searchable {
    let id: String
    let urls: ImageURLStyle
    let color: String
    let links: Links
    
    struct Links {
        let own: String
        let html: String
        let download: String
        let downloadLocation: String
    }
}
