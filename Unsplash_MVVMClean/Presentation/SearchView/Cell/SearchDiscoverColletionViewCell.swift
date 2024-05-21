//
//  SearchDiscoverColletionViewCell.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/21.
//

import UIKit
import SnapKit

final class SearchDiscoverCollectionViewCell: UICollectionViewCell {
    private var imageView: DownloadbleImageView = {
        let imageView = DownloadbleImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.isCancel = false
        imageView.image = nil
        imageView.cancelLoadingImage()
        nameLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [
            imageView,
            nameLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(imageView).inset(5)
        }
    }
    
    func setup(photo: Photo) {
        imageView.downloadImage(url: photo.urls.regular)
        nameLabel.text = photo.user.name
    }
}
