//
//  SearchUserCell.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/07/02.
//

import UIKit
import SnapKit

final class SearchUserCell: UICollectionViewCell {
    private var imageView: DownloadbleImageView = {
        let imageView = DownloadbleImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        
        return label
    }()
    
    private var underLineView: UIView = {
        let lineView: UIView = UIView()
        lineView.backgroundColor = .darkGray
        
        return lineView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.isCancel = true
        imageView.image = nil
        imageView.cancelLoadingImage()
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
            nameLabel,
            userNameLabel,
            underLineView
        ].forEach {
            contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(15)
            $0.width.equalTo(imageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalTo(imageView.snp.trailing).offset(15)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.equalTo(nameLabel.snp.leading).offset(10)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.backgroundColor = .black
    }
    
    func setup(user: User) {
        imageView.downloadImage(url: user.profileImage.medium)
        nameLabel.text = user.name
        userNameLabel.text = user.username
    }
}
