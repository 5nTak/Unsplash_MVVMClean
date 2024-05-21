//
//  AppDelegate.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/16.
//

import UIKit
import Photos

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            UITabBar.appearance().backgroundColor = UIColor.darkGray
        }
        
        requestPhotoLibraryAccess()
        
        return true
    }
    
    // MARK: 사진 접근 권한 요청
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                print("사진 접근 권한 허용")
            } else {
                print("사진 접근 권한 거부")
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
