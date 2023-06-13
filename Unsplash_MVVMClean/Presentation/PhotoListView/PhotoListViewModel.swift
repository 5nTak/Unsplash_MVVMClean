//
//  PhotoListViewModel.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/30.
//

import Foundation

class PhotoListViewModel {
    var photos: [Photo] = [] {
        didSet {
            photosHandler?(photos)
            print(photos)
        }
    }
    var pageNum: Int = 0
    private let photoUseCase: PhotoUseCase
    var photosHandler: (([Photo]) -> Void)?
    
    init(photoUseCase: PhotoUseCase = PhotoUseCase()) {
        self.photoUseCase = photoUseCase
    }
    
    func bindPhotos(closure: @escaping ([Photo]) -> Void) {
        self.photosHandler = closure
    }
    
    func showPhotos() {
        photoUseCase.fetchPhotos(pageNum: pageNum) { result in
            switch result {
            case .success(let data):
                self.photos.append(contentsOf: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
