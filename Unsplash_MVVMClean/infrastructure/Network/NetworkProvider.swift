//
//  NetworkProvider.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/05/18.
//

import Foundation

protocol NetworkProvider {
    var session: URLSession { get }
    func request<T: APIEndpoint>(
        _ request: T,
        completion: @escaping (Result<T.APIResponse, NetworkError>) -> Void
    ) -> Cancellable?
}
