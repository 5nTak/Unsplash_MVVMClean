//
//  SearchRepository.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

protocol SearchRepository {
    func fetchSearchPhotosResult(
        searchText: String,
        searchType: String,
        pageNum: Int,
        completion: @escaping (Result<SearchObject<Photo>, Error>) -> Void
    ) -> URLSessionTask?
    
    func fetchSearchCollectionsResult(
        searchText: String,
        searchType: String,
        pageNum: Int,
        completion: @escaping (Result<SearchObject<Collection>, Error>) -> Void
    ) -> URLSessionTask?
    
    func fetchSearchUsersResult(
        searchText: String,
        searchType: String,
        pageNum: Int,
        completion: @escaping (Result<SearchObject<User>, Error>) -> Void
    ) -> URLSessionTask?
}
