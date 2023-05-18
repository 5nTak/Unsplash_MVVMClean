//
//  NetworkError.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case serverError(description: String)
    case invalidResponse
    case invalidStatusCode(Int, data: Data)
    case invalidData
    case parsingError(description: String, data: Data)
}
