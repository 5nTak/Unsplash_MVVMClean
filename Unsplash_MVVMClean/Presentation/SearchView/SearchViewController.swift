//
//  SearchViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/21.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    private var viewModel = SearchViewModel()
    private var searchViewDataSource = SearchViewCollectionViewDataSource()
    
    private var isShowScopeBar = false {
        willSet {
            searchController.searchBar.showsScopeBar = newValue
        }
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: viewModel.makeSearchResultViewController())
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Photos, Collections, Users"
        searchController.searchBar.tintColor = .white
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.scopeButtonTitles = ["Photos", "Colletions", "Users"]
        
        let selectedTitleTextColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISegmentedControl.appearance().setTitleTextAttributes(selectedTitleTextColor, for: .selected)
        
        let normalTitleTextColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(normalTitleTextColor, for: .normal)
        
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        
        collectionView.register(SearchMainCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchMainCollectionViewHeader")
        collectionView.register(SearchCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCategoryCollectionViewCell")
        collectionView.register(SearchDiscoverCollectionViewCell.self, forCellWithReuseIdentifier: "SearchDiscoverCollectionViewCell")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupCollectionView()
        viewModel.showContents()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationItem.searchController = searchController
        navigationItem.titleView = searchController.searchBar
    }
    
    private func setupCollectionView() {
        view.backgroundColor = .black
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = searchViewDataSource
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        viewModel.bindContents { [weak self] contents in
            self?.searchViewDataSource.contents = contents
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text, !searchBarText.isEmpty {
            isShowScopeBar = true
            viewModel.executeSearch(searchText: searchBarText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        isShowScopeBar = false
        viewModel.resetResult()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        var selectionType: SearchType = .photos
        switch selectedScope {
        case 1:
            selectionType = .collections
        case 2:
            selectionType = .users
        default:
            selectionType = .photos
        }
        
        viewModel.changeSearchType(searchType: selectionType)
        collectionView.setContentOffset(.zero, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
//    셀 선택될 경우 화면전환 discover셀은 DetailView로 넘어가게끔
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch viewModel.contents[indexPath.row].type {
//        case .category:
//        case .discover:
//        default:
//        }
//    }
}

extension SearchViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, _ -> NSCollectionLayoutSection? in
            switch self?.viewModel.contents[section].type {
            case .category:
                return self?.createCategorySection()
            case .discover:
                return self?.createDiscoverSection()
            default:
                return nil
            }
        }
    }
    
    private func createCategorySection() -> NSCollectionLayoutSection {
        let itemMargin: CGFloat = 5
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: itemMargin, leading: itemMargin, bottom: itemMargin, trailing: itemMargin)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = .init(top: 0, leading: itemMargin, bottom: 0, trailing: itemMargin)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createDiscoverSection() -> NSCollectionLayoutSection {
        let itemMargin: CGFloat = 1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: itemMargin, leading: itemMargin, bottom: itemMargin, trailing: itemMargin)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
}
