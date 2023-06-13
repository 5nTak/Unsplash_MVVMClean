//
//  DefaultCategoryRepository.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/25.
//

import Foundation

final class DefaultCategoryRepository: CategoryRepository {
    let networkProvider: DefaultNetworkProvider
    
    init(networkProvider: DefaultNetworkProvider = DefaultNetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) -> URLSessionTask? {
        let request = CategoryEndpoint()
        return self.networkProvider.request(request) { result in
            switch result {
            case .success(let categoryResponse):
                completion(.success(categoryResponse.compactMap { $0.toCategory() }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
