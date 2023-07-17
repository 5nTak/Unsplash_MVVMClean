//
//  PhotoListCollectionViewDataSource.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/01.
//

import UIKit

final class PhotoListCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var photos: [Photo] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListCollectionViewCell", for: indexPath) as? PhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setup(photo: photos[indexPath.row])
        
        return cell
    }
}
