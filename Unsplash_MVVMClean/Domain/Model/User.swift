//
//  User.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

struct User: Searchable, Hashable {
    let id: String
    let name: String
    let username: String
    let profileImage: ProfileImage
    
    struct ProfileImage: Hashable {
        let small: String
        let medium: String
        let large: String
    }
}
