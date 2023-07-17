//
//  PhotoDetailViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/28.
//

import UIKit
import SnapKit

final class PhotoDetailViewController: UIViewController {
    var viewModel: PhotoDetailViewModel
    private var photoDetailViewDataSource = PhotoDetailCollectionViewDataSource()
    private var currentItemRow: Int {
        return Int(collectionView.contentOffset.x / collectionView.frame.size.width)
    }
    
    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var topInfoView: UIView = {
        let topinfoView = UIView()
        topinfoView.backgroundColor = .clear
        
        return topinfoView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        
        return label
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(dismissDetailView), for: .touchUpInside)
        button.tintColor = .white
        
        return button
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.addTarget(self, action: #selector(sharePhoto), for: .touchUpInside)
        button.tintColor = .white
        
        return button
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PhotoDetailCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoDetailCollectionViewCell")
        collectionView.backgroundColor = .black
        collectionView.layoutIfNeeded()
        
        return collectionView
    }()
    
    private var isFullscreen = false {
        willSet {
            if !newValue {
                topInfoView.isHidden = newValue
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                if newValue {
                    self.topInfoView.alpha = 0.0
                } else {
                    self.topInfoView.alpha = 1.0
                }
            }) { [weak self] success in
                self?.topInfoView.isHidden = newValue
            }
        }
        
        didSet {    //상단바와 하단 홈바 hide or show
            self.setNeedsStatusBarAppearanceUpdate()
            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }
    
    private var isVCDismissing: Bool = false {
        willSet {
            if newValue {
                topInfoView.isHidden = true
                view.backgroundColor = .clear
            } else {
                topInfoView.isHidden = isFullscreen
                view.backgroundColor = .black
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupGesture()
    }
    
    private func setup() {
        view.backgroundColor = .black
        
        photoDetailViewDataSource.photos = viewModel.photos
        collectionView.dataSource = photoDetailViewDataSource
        collectionView.delegate = self
        
        [
            collectionView,
            topInfoView
        ].forEach {
            view.addSubview($0)
        }
        
        topInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [
            backButton,
            shareButton,
            titleLabel
        ].forEach {
            topInfoView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(topInfoView.snp.bottom).inset(10)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalTo(topInfoView).inset(20)
            $0.centerY.equalTo(titleLabel)
            $0.width.height.equalTo(20)
        }
        
        shareButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(topInfoView).inset(20)
            $0.centerY.equalTo(titleLabel)
        }
        
        titleLabel.text = viewModel.photos[viewModel.carriedIndex].user.name
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        collectionView.scrollToItem(at: IndexPath(row: viewModel.carriedIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func setupGesture() {
        // fullScreen toggle 제스처 등록
        let fullscreenGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFullScreen))
        self.view.addGestureRecognizer(fullscreenGesture)
        
        // pullDown 제스처 등록
        let pullDownGesture = UIPanGestureRecognizer(target: self, action: #selector(pullDownDismissGesture(sender:)))
        self.view.addGestureRecognizer(pullDownGesture)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return isFullscreen
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return isFullscreen
    }
}

extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let row = currentItemRow
        titleLabel.text = viewModel.photos[row].user.name
        viewModel.carriedIndex = row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension PhotoDetailViewController {
    @objc private func dismissDetailView() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func sharePhoto() {
        viewModel.shareObjects.append(viewModel.photos[viewModel.carriedIndex].links.html)
        
        let activityViewController = UIActivityViewController(activityItems: viewModel.shareObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func toggleFullScreen() {
        isFullscreen.toggle()
    }
    
    @objc private func pullDownDismissGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewModel.viewPullDownY = sender.translation(in: view).y
            if viewModel.viewPullDownY < 0 {
                break
            }
            
            isVCDismissing = true
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewModel.viewPullDownY)
                    self.view.alpha = 1 - (self.viewModel.viewPullDownY) / (self.view.bounds.height * 0.7)
                }
            )
        case .ended:
            if viewModel.viewPullDownY >= 200 {
                dismiss(animated: true)
                break
            }
            
            isVCDismissing = false
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                    self.view.transform = .identity
                    self.view.alpha = 1
                }
            )
        default:
            break
        }
    }
}
