//
//  PhotoDetailCollectionViewDataSource.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/28.
//

import UIKit

final class PhotoDetailCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var photos: [Photo] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoDetailCollectionViewCell", for: indexPath) as? PhotoDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setup(photo: photos[indexPath.row])
        return cell
    }
}
