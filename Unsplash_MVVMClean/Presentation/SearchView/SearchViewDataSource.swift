//
//  SearchViewDataSource.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/21.
//

import UIKit

final class SearchViewCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var contents: [SearchSectionItem] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.section].type {
        case .category:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCategoryCollectionViewCell", for: indexPath) as? SearchCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            guard let categories = contents[indexPath.section].items as? [Category] else {
                return UICollectionViewCell()
            }
            
            let category = categories[indexPath.row]
            cell.setup(category: category)
            
            return cell
            
        case .discover:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDiscoverCollectionViewCell", for: indexPath) as? SearchDiscoverCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            guard let photos = contents[indexPath.section].items as? [Photo] else {
                return UICollectionViewCell()
            }
            
            let photo = photos[indexPath.row]
            cell.setup(photo: photo)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchMainCollectionViewHeader", for: indexPath) as? SearchMainCollectionViewHeader else {
                return UICollectionReusableView()
            }
            
            switch contents[indexPath.section].type {
            case .category:
                headerView.setTitle(title: "Browse by Category")
            
            case .discover:
                headerView.setTitle(title: "Discover")
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
}
