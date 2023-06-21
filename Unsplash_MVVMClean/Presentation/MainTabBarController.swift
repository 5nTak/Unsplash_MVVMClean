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
        
        let loginViewController = LoginNavigationController(rootViewController: LoginViewController())
        loginViewController.tabBarItem = UITabBarItem(
            title: "Login",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )
        
        viewControllers = [
            photoListViewController,
            loginViewController
        ]
    }
    
    private func setupTabBarLayout() {
        tabBar.tintColor = .white
    }
}
