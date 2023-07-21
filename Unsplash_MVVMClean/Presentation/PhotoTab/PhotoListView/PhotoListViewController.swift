//
//  PhotoListViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/30.
//

import UIKit
import SnapKit

final class PhotoListViewController: UIViewController {
    private var viewModel = PhotoListViewModel()
    private var photoListViewDataSource = PhotoListCollectionViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupCollectionView()
        viewModel.showPhotos()
    }
    
    func bind() {
        viewModel.bindPhotos(closure: { [weak self] photos in
            self?.photoListViewDataSource.photos = photos
            self?.updateCollectionView()
        })
    }
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
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
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = photoListViewDataSource
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
        view.backgroundColor = .systemBackground
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    // Gesture
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

extension PhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVM = viewModel.carryData(photos: viewModel.photos, index: indexPath.row)
        let detailVC = PhotoDetailViewController(viewModel: detailVM)
        detailVC.modalPresentationStyle = .overFullScreen
        self.present(detailVC, animated: true)
    }
}

extension PhotoListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.photos.count == indexPath.row + 6 {
                viewModel.pageNum += 1
                viewModel.showPhotos()
                bind()
            }
        }
    }
}
