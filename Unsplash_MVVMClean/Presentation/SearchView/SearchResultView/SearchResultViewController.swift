//
//  SearchResultViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/21.
//

import UIKit
import SnapKit

final class SearchResultViewController: UIViewController {
    private var viewModel: SearchResultViewModel
    private var currentSearchType: SearchType = .photos {
        didSet {
            collectionView.setContentOffset(.zero, animated: false)
        }
    }
    private var searchResultCollectionViewDataSource = SearchResultCollectionViewDataSource()
    private var delegate: DetailViewDelegate?
    private var page: Int = 1
    
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
        viewModel.showItems(page: self.page)
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
            let cellWidth = collectionView.frame.width
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
                self.page += 1
                bindSearchItems()
                viewModel.showItems(page: page
                )
            }
            collectionView.reloadData()
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentSearchType {
        case .photos:
            let detailVM = PhotoListViewModel().carryData(photos: self.viewModel.items as? [Photo] ?? [], index: indexPath.row)
            let detailVC = PhotoDetailViewController(viewModel: detailVM)
            detailVC.modalPresentationStyle = .overFullScreen
            detailVC.delegate = delegate
            detailVC.listView = collectionView
            self.present(detailVC, animated: true)
        case .collections: break
        case .users: break
        }
    }
}
