//
//  ViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/16.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarItem()
        setupTabBarLayout()
    }
    
    private func setupTabBarItem() {
        let photoListViewController = PhotoListViewController()
        photoListViewController.tabBarItem = UITabBarItem(
            title: "Photo",
            image: UIImage(systemName: "photo"),
            selectedImage: UIImage(systemName: "photo.fill")
        )
        
        let photo2 = PhotoListViewController()
        photo2.tabBarItem = UITabBarItem(
            title: "Photo2",
            image: UIImage(systemName: "photo"),
            selectedImage: UIImage(systemName: "photo.fill")
        )
        
        viewControllers = [
            photoListViewController,
            photo2
        ]
    }
    
    private func setupTabBarLayout() {
        tabBar.tintColor = .white
    }
}
