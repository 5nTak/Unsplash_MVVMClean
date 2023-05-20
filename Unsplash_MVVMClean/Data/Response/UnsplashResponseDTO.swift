//
//  UnsplashResponseDTO.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

struct SearchPhotoResponseDTO: Decodable {
    let total: Int
    let totalPages: Int
    let results: [PhotoResponse]
    
    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}

struct SearchCollectionResponseDTO: Decodable {
    let total: Int
    let totalPages: Int
    let results: [CollectionResponse]
    
    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}

struct SearchUserResponseDTO: Decodable {
    let total: Int
    let totalPages: Int
    let results: [UserResponse]
    
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

struct CollectionResponse: Decodable {
    let id: String
    let title: String
    let description: String?
    let totalPhotos: Int
    let previewPhotos: [PreviewPhotosResponse]
    let user: UserResponse
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, user
        case totalPhotos = "total_photos"
        case previewPhotos = "preview_photos"
    }
    
    struct PreviewPhotosResponse: Decodable {
        let id: String
        let urls: ImageURLStyleResponse
    }
}

struct UserResponse: Decodable {
    let id: String
    let name: String
    let username: String
    let profileImage: ProfileImageResponse
    
    enum CodingKeys: String, CodingKey {
        case id, name, username
        case profileImage = "profile_image"
    }
    
    struct ProfileImageResponse: Decodable {
        let small: String
        let medium: String
        let large: String
    }
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
