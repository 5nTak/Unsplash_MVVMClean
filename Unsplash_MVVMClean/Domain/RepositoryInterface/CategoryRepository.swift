//
//  CategoryRepository.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

protocol CategoryRepository {
    func fetchCategories(
        completion: @escaping (Result<[Category], Error>) -> Void
    ) -> URLSessionTask?
}
