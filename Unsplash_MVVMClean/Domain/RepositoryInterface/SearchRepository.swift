//
//  SearchRepository.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

protocol SearchRepository {
    func fetchSearchResult<T: Identifiable>(
        searchText: String,
        searchType: String,
        pageNum: Int,
        completion: @escaping (Result<SearchObject<T>, Error>) -> Void
    ) -> Cancellable?
}
