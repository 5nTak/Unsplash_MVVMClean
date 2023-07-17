//
//  PhotoDetailCollectionViewCell.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/28.
//

import UIKit
import SnapKit

final class PhotoDetailCollectionViewCell: UICollectionViewCell {
    var photo: Photo?
    
    private var imageView: DownloadbleImageView = {
        let imageView = DownloadbleImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    func setup(photo: Photo) {
        self.photo = photo
        setupLayout()
    }
    
    private func setupLayout() {
        self.addSubview(imageView)
        
        guard let photo = photo else {
            return
        }
        
        let cellWidth = contentView.frame.width
        let cellHeight = photo.imageRatio * cellWidth
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(cellHeight)
        }
        
        imageView.downloadImage(url: photo.urls.regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        imageView.isCancel = true
        imageView.image = nil
    }
}
