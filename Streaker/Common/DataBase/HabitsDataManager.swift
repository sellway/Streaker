//
//  DataBaseManager.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/25/23.
//

import Foundation
import RealmSwift

class HabitsDataManager {
    
    static let shared = HabitsDataManager()
    
    init() {} // Приватный инициализатор для синглтона
    
    func saveHabitsToRealm(habitsModel: HabitsModel) {
        do {
            let realm = try Realm()
            try realm.write {
                let habitObject = HabitsModel()
                habitObject.name = habitsModel.name
                habitObject.color = habitsModel.color
                // Копируйте другие свойства, если есть
                realm.add(habitObject)
            }
        } catch {
            print("Error saving habits to Realm: \(error)")
        }
    }
    
    func loadAllHabitsFromRealm() -> [HabitsModel] {
        do {
            let realm = try Realm()
            return Array(realm.objects(HabitsModel.self)) // Возвращает массив всех HabitsModel
        } catch {
            print("Error loading habits from Realm: \(error)")
            return []
        }
    }
}


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
