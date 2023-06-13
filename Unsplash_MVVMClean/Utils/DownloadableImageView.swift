//
//  DownloadableImageView.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/07.
//

import UIKit
import SnapKit

final class DownloadbleImageView: UIImageView {
    
    private var dataTask: URLSessionTask?
    
    var isCancel: Bool = false
    
    private var isFail: Bool = false {
        willSet {
            failMessage.isHidden = !newValue
            loadingView.stopAnimating()
        }
    }
    
    private var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.hidesWhenStopped = true
        loadingView.stopAnimating()
        
        return loadingView
    }()
    
    private var failMessage: UILabel = {
        let failMessage = UILabel()
        failMessage.text = "image_load_fail".localized
        failMessage.font = .systemFont(ofSize: 14, weight: .bold)
        failMessage.textColor = .white
        failMessage.textAlignment = .center
        failMessage.isHidden = true
        failMessage.numberOfLines = 0
        
        return failMessage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        [
            loadingView,
            failMessage
        ].forEach { self.addSubview($0) }
        
        loadingView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        failMessage.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func downloadImage(url: String) {
        isCancel = false
        isFail = false
        
        if let image = ImageCache.shared.object(forKey: url as NSString) {
            self.image = image
            return
        }
        
        guard let url = URL(string: url) else {
            self.isFail = true
            return
        }
        
        loadingView.startAnimating()
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else {
                return
            }
            
            guard error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {
                print("Image DownLoad Error!!")
                self.isFail = true
                return
            }
            
            ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
            
            if self.isCancel {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
                self.loadingView.stopAnimating()
            }
        }
        dataTask.resume()
    }
}

