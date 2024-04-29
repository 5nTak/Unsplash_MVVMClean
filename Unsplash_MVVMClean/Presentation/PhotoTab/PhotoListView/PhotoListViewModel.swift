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
        }
    }
    var pageNum: Int = 0
    private let photoUseCase: PhotoUseCase
    var photosHandler: (([Photo]) -> Void)?
    
    init(photoUseCase: PhotoUseCase = PhotoUseCase()) {
        self.photoUseCase = photoUseCase
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
    
    func carryData(photos: [Photo], index: Int) -> PhotoDetailViewModel {
        let detailViewModel = PhotoDetailViewModel()
        detailViewModel.photos = photos
        detailViewModel.carriedIndex = index
        return detailViewModel
    }
}
