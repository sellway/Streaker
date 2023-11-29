//
//  String + ext.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/25/23.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, comment: "")
    }
}
