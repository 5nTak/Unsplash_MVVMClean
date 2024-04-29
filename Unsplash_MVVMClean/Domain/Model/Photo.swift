//
//  Photo.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

struct Photo: Searchable, Hashable {
    let id: String
    let uuid = UUID()
    let urls: ImageURLStyle
    let color: String
    let links: Links
    let width: Int
    let height: Int
    let user: User
    
    var imageRatio: CGFloat {
        return CGFloat(height) / CGFloat(width)
    }
    
    struct Links: Hashable {
        let own: String
        let html: String
        let download: String
        let downloadLocation: String
    }
    
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
        && lhs.uuid == rhs.uuid
        && lhs.urls == rhs.urls
        && lhs.color == rhs.color
        && lhs.links == rhs.links
        && lhs.width == rhs.width
        && lhs.height == rhs.height
        && lhs.user == rhs.user
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(uuid)
        hasher.combine(urls)
        hasher.combine(color)
        hasher.combine(links)
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(user)
    }
}
