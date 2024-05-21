//
//  SearchResultViewModel.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/23.
//

import Foundation

final class SearchResultViewModel {
    
    var items: [Searchable] = [] {
        didSet {
            searchHandler?(items)
        }
    }
    
    private var searchHandler: (([Searchable]) -> Void)?
    private var searchTypeHandler: ((SearchType) -> Void)?
    private var searchText: String = ""
    var pageNum: Int = 0
    private var searchLastPageNum = 0
    var currentSearchType: SearchType = .photos {
        didSet {
            verifySearch()
//            prepareSearch()
            searchHandler?(items)
            searchTypeHandler?(currentSearchType)
        }
    }
    private var isSearchFetching = false
    
    private let photoSearchUseCase: SearchUseCase
    private let collectionSearchUseCase: SearchUseCase
    private let userSearchUseCase: SearchUseCase
    
    init(photoSearchUseCase: SearchUseCase = SearchUseCase(),
         collectionSearchUseCase: SearchUseCase = SearchUseCase(),
         userSearchUseCase: SearchUseCase = SearchUseCase()) {
        self.photoSearchUseCase = photoSearchUseCase
        self.collectionSearchUseCase = collectionSearchUseCase
        self.userSearchUseCase = userSearchUseCase
    }
    
    func bindSearchItems(clousre: @escaping ([Searchable]) -> Void) {
        self.searchHandler = clousre
    }
    
    func bindSearchTypes(closure: @escaping (SearchType) -> Void) {
        self.searchTypeHandler = closure
    }
    
    func showItems(page: Int) {
        switch currentSearchType {
        case .photos:
            self.showPhotoList(page: page)
        case .collections:
            self.showCollectionList(page: page)
        case .users:
            self.showUserList(page: page)
        }
    }
    
    private var task: URLSessionTask?
    func showPhotoList(page: Int) {
        task = photoSearchUseCase.fetchSearchPhotos(searchText: searchText, searchType: currentSearchType.rawValue, pageNum: page) { result in
            switch result {
            case .success(let data):
                self.items.append(contentsOf: data.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func showCollectionList(page: Int) {
        task = collectionSearchUseCase.fetchSearchCollections(searchText: searchText, searchType: currentSearchType.rawValue, pageNum: page) { result in
            switch result {
            case .success(let data):
                self.items.append(contentsOf: data.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showUserList(page: Int) {
        task = userSearchUseCase.fetchSearchUsers(searchText: searchText, searchType: currentSearchType.rawValue, pageNum: page) { result in
            switch result {
            case .success(let data):
                self.items.append(contentsOf: data.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func resetResult() {
        items = []
    }
    
    private func initialSearchState() {
        task?.cancel()
        isSearchFetching = false
        pageNum = 0
        searchLastPageNum = -1
    }
    
    func verifySearch(searchText: String = "") {
        resetResult()

        if !searchText.isEmpty {
            self.searchText = searchText
        }
        
        initialSearchState()
    }
    
    func prepareSearch(page: Int) {
        if pageNum == searchLastPageNum {
            return
        }
        if isSearchFetching {
            return
        }
        isSearchFetching = true
        self.showItems(page: page)
    }
}
