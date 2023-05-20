//
//  Search.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

protocol Searchable { }

struct SearchObject<T: Searchable> {
    let total: Int
    let totalPages: Int
    let results: [T]
}
