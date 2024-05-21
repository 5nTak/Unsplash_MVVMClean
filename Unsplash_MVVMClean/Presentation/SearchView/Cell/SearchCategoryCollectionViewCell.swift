//
//  SearchCategoryCollectionViewCell.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/21.
//

import UIKit
import SnapKit

final class SearchCategoryCollectionViewCell: UICollectionViewCell {
    private var imageView: DownloadbleImageView = {
        let imageView = DownloadbleImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.isCancel = true
        imageView.image = nil
        imageView.cancelLoadingImage()
        titleLabel.text = nil
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
            titleLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(imageView).inset(8)
        }
    }
    
    func setup(category: Category) {
        imageView.downloadImage(url: category.coverPhoto.urls.thumb)
        titleLabel.text = category.title
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
