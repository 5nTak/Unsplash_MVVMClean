//
//  PhotoUseCase.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/26.
//

import Foundation

final class PhotoUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository = DefaultPhotoRepository()) {
        self.photoRepository = photoRepository
    }
    
    func fetchPhotos(pageNum: Int, completion: @escaping (Result<[Photo], Error>) -> Void) -> URLSessionTask? {
        return photoRepository.fetchPhotos(pageNum: pageNum, completion: completion)
    }
}
