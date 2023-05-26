//
//  User.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

struct User: Searchable {
    let id: String
    let name: String
    let username: String
    let profileImage: ProfileImage
    
    struct ProfileImage {
        let small: String
        let medium: String
        let large: String
    }
}
