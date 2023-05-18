//
//  SearchRepository.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

protocol SearchRepository {
    func fetchSearchResult(
        searchText: String,
        searchType: String,
        pageNum: Int,
        completion: @escaping (Result<SearchObject<[Photo]>, Error>) -> Void
    ) -> Cancellable?
}
