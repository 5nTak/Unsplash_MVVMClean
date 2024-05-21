//
//  PhotoListCollectionViewCell.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/01.
//

import UIKit
import SnapKit

final class PhotoListCollectionViewCell: UICollectionViewCell {
    private var photoImageView: DownloadbleImageView = {
        let imageView = DownloadbleImageView(frame: .zero)
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var photographerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        photoImageView.isCancel = true
        photoImageView.image = nil
        photographerLabel.text = nil
        photoImageView.cancelLoadingImage()
    }

    func setup(photo: Photo) {
        photoImageView.downloadImage(url: photo.urls.regular)
        photographerLabel.text = photo.user.name
    }
    
    private func setupLayout() {
        [
            photoImageView,
            photographerLabel
        ].forEach { contentView.addSubview($0) }
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        photographerLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
        }
    }
}
