//
//  SearchPhotoUseCase.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/26.
//

import Foundation

final class SearchUseCase {
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository = DefaultSearchRepository()) {
        self.searchRepository = searchRepository
    }
    
    func fetchSearchPhotos(searchText: String, searchType: String, pageNum: Int, completion: @escaping (Result<SearchObject<Photo>, Error>) -> Void) -> URLSessionTask? {
        return searchRepository.fetchSearchPhotosResult(searchText: searchText, searchType: searchType, pageNum: pageNum, completion: completion)
    }
    
    func fetchSearchCollections(searchText: String, searchType: String, pageNum: Int, completion: @escaping (Result<SearchObject<Collection>, Error>) -> Void) -> URLSessionTask? {
        return searchRepository.fetchSearchCollectionsResult(searchText: searchText, searchType: searchType, pageNum: pageNum, completion: completion)
    }
    
    func fetchSearchUsers(searchText: String, searchType: String, pageNum: Int, completion: @escaping (Result<SearchObject<User>, Error>) -> Void) -> URLSessionTask? {
        return searchRepository.fetchSearchUsersResult(searchText: searchText, searchType: searchType, pageNum: pageNum, completion: completion)
    }
}
