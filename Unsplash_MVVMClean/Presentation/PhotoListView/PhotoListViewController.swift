//
//  PhotoListViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/30.
//

import UIKit
import SnapKit

final class PhotoListViewController: UIViewController {
    private var viewModel: PhotoListViewModel = PhotoListViewModel()
    private var photoListViewDataSource = PhotoListCollectionViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.showPhotos()
        bind()
        setupCollectionViewLayout()
    }
    
    func bind() {
        viewModel.bindPhotos(closure: { [weak self] photos in
            self?.photoListViewDataSource.photos = photos
        })
    }
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.invalidateLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
        
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        collectionView.refreshControl = refreshController
        
        return collectionView
    }()
    
    @objc func refreshPhotos() {
        viewModel.photos = []
        viewModel.showPhotos()
        collectionView.refreshControl?.endRefreshing()
    }
    
    private func setupCollectionViewLayout() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = photoListViewDataSource
        collectionView.prefetchDataSource = self
        
        view.backgroundColor = .systemBackground
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            let velocityY = velocity.y
            guard velocityY != 0 else {
                return
            }
            
            var tabbarHeight: CGFloat = UIScreen.main.bounds.maxY
            var tabbarAlpha: CGFloat = 0
            if velocityY < 0 {
                tabbarHeight -= self?.tabBarController?.tabBar.frame.height ?? 0
                tabbarAlpha = 1
            }
            
            self?.tabBarController?.tabBar.alpha = tabbarAlpha
            self?.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: tabbarHeight)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = viewModel.photos[indexPath.row]
        let cellWidth = collectionView.frame.width
        let cellHeight = photo.imageRatio * cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.5, left: 0, bottom: 0.5, right: 0)
    }
}

extension PhotoListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if viewModel.photos.count == 0 {
            return
        }

        guard let row = indexPaths.first?.row else {
            return
        }

        if row == viewModel.photos.count - 11 || row == viewModel.photos.count - 6 || row == viewModel.photos.count - 1 {
            bind()
        }
    }
}
