/*

Этот файл DataBaseManager.swift включает в себя следующие классы и функциональности:
1 - HabitsDataManager: Управляет операциями с данными для объектов HabitsModel в базе данных Realm.
2 - saveHabitsToRealm: Сохраняет или обновляет привычки в базе данных, используя транзакции Realm.
3 - loadAllHabitsFromRealm: Загружает все объекты HabitsModel из базы данных Realm в массив.
4 - ConfigurationStorage: Управляет сохранением и извлечением настроек и конфигураций приложения, используя UserDefaults.
5 - Предоставляет доступ к настройкам, таким как счетчик дней и последняя дата модификации, через свойства с сохранением и загрузкой значений.
6 - mainData: Свойство для хранения сложных данных в формате массива словарей.

*/
import Foundation
import RealmSwift

class HabitsDataManager {
    
    static let shared = HabitsDataManager()
    
    init() {} // Приватный инициализатор для синглтона
    
    func saveHabitsToRealm(habitsModel: HabitsModel) {
        do {
            let realm = try Realm()
            try realm.write {
                if let existingHabit = realm.object(ofType: HabitsModel.self, forPrimaryKey: habitsModel.id) {
                    existingHabit.counter = habitsModel.counter
                    print("Updated existing habit: \(existingHabit.name), counter: \(existingHabit.counter)")
                } else {
                    realm.add(habitsModel)
                    print("Added new habit: \(habitsModel.name), counter: \(habitsModel.counter)")
                }
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
