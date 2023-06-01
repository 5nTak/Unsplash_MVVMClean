//
//  DefaultPhotoRepository.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/25.
//

import Foundation

final class DefaultPhotoRepository: PhotoRepository {
    let networkProvider: DefaultNetworkProvider
    
    init(networkProvider: DefaultNetworkProvider = DefaultNetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    func fetchPhotos(pageNum: Int, completion: @escaping (Result<[Photo], Error>) -> Void) -> URLSessionTask? {
        let request = PhotoListEndpoint(pageNum: pageNum)
        return self.networkProvider.request(request) { result in
            switch result {
            case .success(let photoResponse):
                completion(.success(photoResponse.compactMap { $0.toPhoto() }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
