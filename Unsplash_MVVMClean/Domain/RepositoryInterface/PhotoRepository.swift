//
//  PhotoRepository.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

protocol PhotoRepository {
    func fetchPhotos(
        pageNum: Int,
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) -> URLSessionTask?
}
