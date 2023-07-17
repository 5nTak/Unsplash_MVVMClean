//
//  SearchViewModel.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/21.
//

import Foundation

final class SearchViewModel {
    private enum ContentsIndex {
        static let categoryType = 0
        static let discoverType = 1
    }
    
    var contents: [SearchSectionItem] = [
        SearchSectionItem(type: .category, items: []),
        SearchSectionItem(type: .discover, items: [])
    ] {
        didSet {
            contentsHandler?(contents)
        }
    }
    
    var categoryItems: [Category] = [] {
        didSet {
            contents[ContentsIndex.categoryType].items.append(contentsOf: categoryItems)
        }
    }
    var discoverItems: [Photo] = [] {
        didSet {
            contents[ContentsIndex.discoverType].items.append(contentsOf: discoverItems)
        }
    }
    
    private var categoryUseCase: CategoryUseCase
    private var discoverUseCase: PhotoUseCase
    
    var contentsHandler: (([SearchSectionItem]) -> Void)?
    
    var discoverPageNum = 0
    var isFetching = false
    
    private let searchResultViewModel = SearchResultViewModel()
    
    init(categoryUseCase: CategoryUseCase = CategoryUseCase(),
         discoverUseCase: PhotoUseCase = PhotoUseCase()) {
        self.categoryUseCase = categoryUseCase
        self.discoverUseCase = discoverUseCase
    }
    
    func bindContents(closure: @escaping ([SearchSectionItem]) -> Void) {
        self.contentsHandler = closure
    }
    
    func showContents() {
        fetchCategory()
        fetchDiscover()
    }
    
    func fetchCategory() {
        categoryUseCase.fetchCategories { result in
            switch result {
            case .success(let data):
                self.categoryItems.append(contentsOf: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDiscover() {
        if isFetching {
            return
        }
        isFetching = true
        
        discoverUseCase.fetchPhotos(pageNum: discoverPageNum) { result in
            switch result {
            case .success(let data):
                self.discoverItems.append(contentsOf: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func makeSearchResultViewController() -> SearchResultViewController {
        return SearchResultViewController(viewModel: searchResultViewModel)
    }
    
    func resetResult() {
        searchResultViewModel.resetResult()
    }
    
    func executeSearch(searchText: String) {
        searchResultViewModel.verifySearch(searchText: searchText)
        searchResultViewModel.prepareSearch()
    }
    
    func changeSearchType(searchType: SearchType) {
        searchResultViewModel.currentSearchType = searchType
    }
}
