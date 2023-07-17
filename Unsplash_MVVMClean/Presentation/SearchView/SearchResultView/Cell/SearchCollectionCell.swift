//
//  SearchCollectionCell.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/07/02.
//

import UIKit
import SnapKit

final class SearchCollectionCell: UICollectionViewCell {
    private var firstImageView: DownloadbleImageView = {
        let imageView = DownloadbleImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var secondImageView: DownloadbleImageView = {
        let imageView = DownloadbleImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var thirdImageView: DownloadbleImageView = {
        let imageView = DownloadbleImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    private var collectionInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .left
        
        return label
    }()
    
    private var collectionInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [
            firstImageView,
            secondImageView,
            thirdImageView
        ].forEach {
            $0.isCancel = true
            $0.image = nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .init(white: 0.15, alpha: 1)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        [
            firstImageView,
            secondImageView,
            thirdImageView
        ].forEach {
            imageStackView.addArrangedSubview($0)
        }
        
        [
            titleLabel,
            collectionInfoLabel
        ].forEach {
            collectionInfoStackView.addArrangedSubview($0)
        }
        
        [
            imageStackView,
            collectionInfoStackView
        ].forEach {
            contentView.addSubview($0)
        }
        
        imageStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalTo(contentView.frame.width)
            $0.height.equalTo(100)
        }
        
        collectionInfoStackView.snp.makeConstraints {
            $0.top.equalTo(imageStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setup(collection: Collection) {
        firstImageView.downloadImage(url: collection.previewPhotos[0].urls.thumb)
        secondImageView.downloadImage(url: collection.previewPhotos[1].urls.thumb)
        thirdImageView.downloadImage(url: collection.previewPhotos[2].urls.thumb)
        titleLabel.text = collection.title
        collectionInfoLabel.text = "\(collection.totalPhotos) photos • Curated by \(collection.user.username)"
    }
}
