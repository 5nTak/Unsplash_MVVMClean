//
//  UnsplashResponseDTO.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

struct SearchObjectResponseDTO<T: Decodable> {
    let total: Int
    let totalPages: Int
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}

struct PhotoResponse: Decodable {
    let id: String
    let urls: ImageURLStyleResponse
    let color: String
    let links: Links
    
    struct Links: Decodable {
        let own: String
        let html: String
        let download: String
        let downloadLocation: String
        
        enum CodingKeys: String, CodingKey {
            case html, download
            case own = "self"
            case downloadLocation = "download_location"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, urls, color, links
    }
}

struct ImageURLStyleResponse: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct CategoryResponse: Decodable {
    let id: String
    let title: String
    let coverPhoto: CoverPhotoResponse
    
    struct CoverPhotoResponse: Decodable {
        let urls: ImageURLStyleResponse
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case coverPhoto = "cover_photo"
    }
}
