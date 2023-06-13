//
//  String+Extension.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/07.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
