//
//  SearchResultViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/21.
//

import UIKit
import SnapKit

final class SearchResultViewController: UIViewController {
    var viewModel: SearchResultViewModel
    var currentSearchType: SearchType = .photos {
        didSet {
            collectionView.setContentOffset(.zero, animated: false)
        }
    }
    private var searchResultCollectionViewDataSource = SearchResultCollectionViewDataSource()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
        collectionView.register(SearchCollectionCell.self, forCellWithReuseIdentifier: "SearchCollectionCell")
        collectionView.register(SearchUserCell.self, forCellWithReuseIdentifier: "SearchUserCell")
        
        collectionView.backgroundColor = .black
        
        return collectionView
    }()
    
    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSearchItems()
        bindSearchType()
        viewModel.showItems()
        setupCollectionView()

    }
    
    private func bindSearchItems() {
        viewModel.bindSearchItems { [weak self] items in
            self?.searchResultCollectionViewDataSource.items = items
            self?.updateCollectionView()
        }
    }
    
    private func bindSearchType() {
        viewModel.bindSearchTypes { [weak self] type in
            self?.searchResultCollectionViewDataSource.currentSearchType = type
            self?.currentSearchType = type
            self?.bindSearchItems()
            self?.updateCollectionView()
        }
    }
    
    private func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = searchResultCollectionViewDataSource
        collectionView.prefetchDataSource = self
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.backgroundColor = .black
        updateCollectionView()
        
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = .zero
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch currentSearchType {
        case .photos:
            guard let photo = viewModel.items[indexPath.row] as? Photo else {
                return .zero
            }
            let cellWidth = collectionView.frame.width
            let cellHeight = photo.imageRatio * cellWidth
            return CGSize(width: cellWidth, height: cellHeight)
            
        case .collections:
            let cellWidth = collectionView.frame.width - 20
            let cellHeight = cellWidth * 0.4
            return CGSize(width: cellWidth, height: cellHeight)
            
        case .users:
            let cellWidth = collectionView.frame.width
            let cellHeight: CGFloat = 100
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch currentSearchType {
        case .photos:
            return UIEdgeInsets(top: 45, left: 0, bottom: 0.5, right: 0)
            
        case .collections:
            return UIEdgeInsets(top: 45, left: 10, bottom: 5, right: 10)
            
        case .users:
            return UIEdgeInsets(top: 45, left: 0, bottom: 5, right: 0)
        }
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.items.count == indexPath.row + 2 {
                viewModel.pageNum += 1
                bindSearchItems()
                viewModel.showItems()
            }
            collectionView.reloadData()
        }
    }
}
