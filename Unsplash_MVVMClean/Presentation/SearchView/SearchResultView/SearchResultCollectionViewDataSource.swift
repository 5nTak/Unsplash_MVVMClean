//
//  SearchResultCollectionViewDataSource.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/07/03.
//

import UIKit

final class SearchResultCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var items: [Any] = []
    var currentSearchType: SearchType = .photos
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch currentSearchType {
        case .photos:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListCollectionViewCell", for: indexPath) as? PhotoListCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if items.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    guard let item = self.items[indexPath.row] as? Photo else {
                        return
                    }
                    cell.setup(photo: item)
                }
                return cell
            } else {
                if items.count - 1 < indexPath.row {
                    return UICollectionViewCell()
                }
                
                guard let item = items[indexPath.row] as? Photo else {
                    return UICollectionViewCell()
                }
                
                cell.setup(photo: item)
                
                return cell
            }
            
        case .collections:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionCell", for: indexPath) as? SearchCollectionCell else {
                return UICollectionViewCell()
            }
            
            if items.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    guard let item = self.items[indexPath.row] as? Collection else {
                        return
                    }
                cell.setup(collection: item)
                }
                return cell
            } else {
                if items.count - 1 < indexPath.row {
                    return UICollectionViewCell()
                }
                
                guard let item = items[indexPath.row] as? Collection else {
                    return UICollectionViewCell()
                }
                
                cell.setup(collection: item)
                
                return cell
            }
            
            
        case .users:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchUserCell", for: indexPath) as? SearchUserCell else {
                return UICollectionViewCell()
            }
            
            if items.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    guard let item = self.items[indexPath.row] as? User else {
                        return
                    }
                cell.setup(user: item)
                }
                return cell
            } else {
                if items.count - 1 < indexPath.row {
                    return UICollectionViewCell()
                }
                
                guard let item = items[indexPath.row] as? User else {
                    return UICollectionViewCell()
                }
                
                cell.setup(user: item)
                
                return cell
            }
        }
    }
}
