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
            title: "Photo".localized,
            image: UIImage(systemName: "photo"),
            selectedImage: UIImage(systemName: "photo.fill")
        )
        
        let searchViewController = SearchNavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem = UITabBarItem(
            title: "Search".localized,
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        let loginViewController = LoginNavigationController(rootViewController: LoginViewController())
        loginViewController.tabBarItem = UITabBarItem(
            title: "Login".localized,
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )
        
        viewControllers = [
            photoListViewController,
            searchViewController,
            loginViewController
        ]
    }
    
    private func setupTabBarLayout() {
        tabBar.tintColor = .white
    }
}
