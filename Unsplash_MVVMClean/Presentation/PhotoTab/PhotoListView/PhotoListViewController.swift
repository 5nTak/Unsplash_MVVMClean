//
//  PhotoListViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/30.
//

import UIKit
import SnapKit

final class PhotoListViewController: UIViewController {
    enum Section: CaseIterable {
        case list
    }
    
    private var viewModel = PhotoListViewModel()
    private var photoListViewDataSource = PhotoListCollectionViewDataSource()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    private var delegate: DetailViewDelegate?
    private var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupCollectionView()
        viewModel.showPhotos(page: self.page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func bind() {
        viewModel.photosHandler = { photos in
            self.applySnapshot(photos: photos)
        }
    }
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collectionView
    }()
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        configureDataSource()
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
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
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PhotoListCollectionViewCell, Photo> { cell, indexPath, photo in
            cell.setup(photo: photo)
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView, cellProvider: { collectionView, indexPath, photo in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: photo)
        })
    }
    
    private func applySnapshot(photos: [Photo]) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
            snapshot.appendSections([.list])
            snapshot.appendItems(photos)
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    // Gesture
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard velocity.y != 0 else {
                return
            }
            
            var tabbarHeight: CGFloat = UIScreen.main.bounds.maxY
            var tabbarAlpha: CGFloat = 0
            
            if velocity.y < 0 {
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
        detailVC.delegate = delegate
        detailVC.listView = collectionView
        self.present(detailVC, animated: true)
    }
}

extension PhotoListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.photos.count == indexPath.row + 4 {
                self.page += 1
                bind()
                viewModel.showPhotos(page: self.page)
            }
        }
    }
}
