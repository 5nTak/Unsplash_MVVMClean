//
//  ImageCache.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/07.
//

import UIKit

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
