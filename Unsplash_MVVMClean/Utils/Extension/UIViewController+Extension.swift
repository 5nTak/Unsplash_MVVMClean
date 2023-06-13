//
//  UIViewController+Extension.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/07.
//

import UIKit

extension UIViewController {
    func showErrorAlert(error: NetworkError) {
        var errorMessage = ""
        
        switch error {
        case .invalidRequest:
            errorMessage = "error_network".localized
        case .invalidResponse:
            errorMessage = "error_network".localized
        case .parsingError:
            errorMessage = "error_json_parsing".localized
        case .invalidData:
            errorMessage = "error_data".localized
        default:
            break
        }
        
        let errorTitle = "error".localized
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ok", style: .default)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}
