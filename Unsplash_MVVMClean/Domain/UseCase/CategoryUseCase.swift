//
//  CategoryUseCase.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/26.
//

import Foundation

final class CategoryUseCase {
    private let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository = DefaultCategoryRepository()) {
        self.categoryRepository = categoryRepository
    }
    
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) -> URLSessionTask? {
        return categoryRepository.fetchCategories(completion: completion)
    }
}
