//
//  UnsplashResponseDTO+Mapping.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

// MARK: - SearchResponseDTO
extension SearchPhotoResponseDTO {
    func toDomain() -> SearchObject<Photo> {
        return SearchObject(total: self.total,
                            totalPages: self.totalPages,
                            results: self.results.compactMap { $0.toPhoto()} )
    }
}

extension SearchCollectionResponseDTO {
    func toDomain() -> SearchObject<Collection> {
        return SearchObject(total: self.total,
                            totalPages: self.totalPages,
                            results: self.results.compactMap { $0.toCollection() })
    }
}

extension SearchUserResponseDTO {
    func toDomain() -> SearchObject<User> {
        return SearchObject(total: self.total,
                            totalPages: self.totalPages,
                            results: self.results.compactMap { $0.toUser() })
    }
}

// MARK: - Response
extension PhotoResponse {
    func toLink() -> Photo.Links {
        return Photo.Links(own: self.links.own,
                           html: self.links.html,
                           download: self.links.download,
                           downloadLocation: self.links.downloadLocation)
    }
    
    func toPhoto() -> Photo {
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

extension CollectionResponse {
    func toPreviewPhoto(_ previewPhotoResponse: PreviewPhotosResponse) -> Collection.PreviewPhoto {
        return Collection.PreviewPhoto(id: previewPhotoResponse.id, urls: previewPhotoResponse.urls.toImageURLStyle())
    }
    
    func toPreviewPhotos() -> [Collection.PreviewPhoto] {
        return self.previewPhotos.compactMap { toPreviewPhoto($0) }
    }
    
    func toCollection() -> Collection? {
        return Collection(id: self.id,
                          title: self.title,
                          description: self.description,
                          totalPhotos: self.totalPhotos,
                          previewPhotos: self.toPreviewPhotos(),
                          user: self.user.toUser())
    }
}

extension UserResponse {
    func toProfileImage() -> User.ProfileImage {
        return User.ProfileImage(small: self.profileImage.small,
                                 medium: self.profileImage.medium,
                                 large: self.profileImage.large)
    }
    
    func toUser() -> User {
        return User(id: self.id,
                    name: self.name,
                    username: self.username,
                    profileImage: self.toProfileImage())
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
