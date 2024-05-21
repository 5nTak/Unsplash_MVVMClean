//
//  DownloadableImageView.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/07.
//

import UIKit
import SnapKit
import Photos

final class DownloadbleImageView: UIImageView {
    
    private var dataTask: URLSessionTask?
    
    var isCancel: Bool = false
    
    private var isFail: Bool = false {
        willSet {
            DispatchQueue.main.async {
                self.failMessage.isHidden = !newValue
                self.loadingView.stopAnimating()
            }
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
        setupLongPressGesture()
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
    
    func cancelLoadingImage() {
        dataTask?.cancel()
        dataTask = nil
    }
    
    // MARK: Long Press Gesture
    func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.addGestureRecognizer(longPressGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let downloadAction = UIAlertAction(title: "Download".localized, style: .default) { _ in
                if let image = self.image {
                    self.saveImageToPhotoLibrary(image: image)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            alertController.addAction(downloadAction)
            alertController.addAction(cancelAction)
            
            if let viewController = self.parentViewController {
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func saveImageToPhotoLibrary(image: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            parentResponder = responder.next
        }
        return nil
    }
}
