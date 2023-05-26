//
//  UnsplahAPIEndpoint.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/20.
//

import Foundation

protocol UnsplashAPIEndpoint: APIEndpoint, UnsplashAPIRequestSpec { }

protocol UnsplashAPIRequestSpec {
    var serviceKey: String { get }
}

extension UnsplashAPIRequestSpec {
    var baseURL: URL? {
        return URL(string: "https://api.unsplash.com")
    }
    
    var serviceKey: String {
        return "pVdV-xznGr9AF-bVyqlQDf4t6RtBGX8y2Ij4ehFzQko"
    }
}
