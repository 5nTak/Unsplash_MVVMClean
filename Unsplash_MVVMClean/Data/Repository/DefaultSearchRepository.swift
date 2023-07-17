//
//  DefaultSearchRepository.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/25.
//

import Foundation

final class DefaultSearchRepository: SearchRepository {
    let networkProvider: DefaultNetworkProvider
    
    init(networkProvider: DefaultNetworkProvider = DefaultNetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    func fetchSearchPhotosResult(searchText: String, searchType: String, pageNum: Int, completion: @escaping (Result<SearchObject<Photo>, Error>) -> Void) -> URLSessionTask? {
        let request = SearchPhotoEndpoint(pageNum: pageNum, searchText: searchText)
        return self.networkProvider.request(request) { result in
            switch result {
            case .success(let searchPhotoResponseDTO):
                completion(.success(searchPhotoResponseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearchCollectionsResult(searchText: String, searchType: String, pageNum: Int, completion: @escaping (Result<SearchObject<Collection>, Error>) -> Void) -> URLSessionTask? {
        let request = SearchCollectionEndpoint(pageNum: pageNum, searchText: searchText)
        return self.networkProvider.request(request) { result in
            switch result {
            case .success(let searchCollectionResponseDTO):
                completion(.success(searchCollectionResponseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearchUsersResult(searchText: String, searchType: String, pageNum: Int, completion: @escaping (Result<SearchObject<User>, Error>) -> Void) -> URLSessionTask? {
        let request = SearchUserEndpoint(pageNum: pageNum, searchText: searchText)
        return self.networkProvider.request(request) { result in
            switch result {
            case .success(let searchUserResponseDTO):
                completion(.success(searchUserResponseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
