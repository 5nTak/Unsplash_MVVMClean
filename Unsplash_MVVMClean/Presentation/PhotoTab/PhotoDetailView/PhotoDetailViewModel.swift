//
//  PhotoDetailViewModel.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/28.
//

import UIKit

final class PhotoDetailViewModel {
    var photos: [Photo] = [] 
    var carriedIndex: Int = 0
    var viewPullDownY: CGFloat = 0
    var shareObjects: [Any] = []
}
