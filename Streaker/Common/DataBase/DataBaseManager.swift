//
//  DataBaseManager.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/25/23.
//

import Foundation

final class ConfigurationStorage {

    enum StorageKeys: String, RawRepresentable {
        case dayCounter
        case lastModifiedDate
        case mainData
    }

    var dayCounter: Int? {
        get {
            return userDefaults.integer(forKey: StorageKeys.dayCounter.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: StorageKeys.dayCounter.rawValue)
        }
    }

    var lastModifiedDate: Date? {
        get {
            return userDefaults.object(forKey: StorageKeys.lastModifiedDate.rawValue) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: StorageKeys.lastModifiedDate.rawValue)
        }
    }

    var mainData: [[String: [[Int]]]] {
        get {
            return userDefaults.object(forKey: StorageKeys.mainData.rawValue) as? [[String: [[Int]]]] ?? []
        }
        set {
            userDefaults.set(newValue, forKey: StorageKeys.mainData.rawValue)
        }
    }
    
    

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
}
