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
    
    var searchHandler: (([Searchable]) -> Void)?
    var searchText: String = ""
    var searchType: String = ""
    var pageNum: Int = 0
    var searchLastPageNum = 0
    var currentSearchType: SearchType = .photos {
        didSet {
            verifySearch()
            prepareSearch()
            searchTypeHandler?(currentSearchType)
        }
    }
    var searchTypeHandler: ((SearchType) -> Void)?
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
    
    func showItems() {
        switch currentSearchType {
        case .photos:
            self.showPhotoList()
        case .collections:
            self.showCollectionList()
        case .users:
            self.showUserList()
        }
    }
    
    var task: URLSessionTask?
    func showPhotoList() {
        task = photoSearchUseCase.fetchSearchPhotos(searchText: searchText, searchType: searchType, pageNum: pageNum) { result in
            switch result {
            case .success(let data):
                self.items.append(contentsOf: data.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showCollectionList() {
        task = collectionSearchUseCase.fetchSearchCollections(searchText: searchText, searchType: searchType, pageNum: pageNum) { result in
            switch result {
            case .success(let data):
                self.items.append(contentsOf: data.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showUserList() {
        task = userSearchUseCase.fetchSearchUsers(searchText: searchText, searchType: searchType, pageNum: pageNum) { result in
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
    
    func initialSearchState() {
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
    
    func prepareSearch() {
        if pageNum == searchLastPageNum {
            return
        }
        if isSearchFetching {
            return
        }
        isSearchFetching = true
        self.showItems()
    }
}
