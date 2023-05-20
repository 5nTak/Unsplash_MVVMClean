//
//  UnsplashResponseDTO+Mapping.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

extension SearchObjectResponseDTO {
    func toDomain() -> SearchObject<T> {
        return SearchObject(total: self.total,
                            totalPages: self.totalPages,
                            results: self.results)
    }
}

extension PhotoResponse {
    func toLink() -> Photo.Links {
        return Photo.Links(own: self.links.own,
                           html: self.links.html,
                           download: self.links.download,
                           downloadLocation: self.links.downloadLocation)
    }
    
    func toPhoto() -> Photo? {
        return Photo(id: self.id,
                     urls: self.urls.toImageURLStyle(),
                     color: self.color,
                     links: self.toLink())
    }
}

extension ImageURLStyleResponse {
    func toImageURLStyle() -> ImageURLStyle {
        return ImageURLStyle(raw: self.raw,
                             full: self.full,
                             regular: self.regular,
                             small: self.small,
                             thumb: self.thumb)
    }
}

extension CategoryResponse {
    func toCoverPhoto() -> Category.CoverPhoto {
        return Category.CoverPhoto(urls: self.coverPhoto.urls.toImageURLStyle())
    }
    
    func toCategory() -> Category {
        return Category(id: self.id,
                        title: self.title,
                        coverPhoto: self.toCoverPhoto())
    }
}
