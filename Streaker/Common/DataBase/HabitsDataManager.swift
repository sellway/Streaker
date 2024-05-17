import Foundation
import RealmSwift

// Менеджер для работы с данными привычек в базе данных Realm
class HabitsDataManager {
    static let shared = HabitsDataManager()
    
    private init() {} // Приватный инициализатор для синглтона
        
    // Функция для обновления и получения данных привычек и их ячеек
    func loadHabitsData() -> [[HabitCellModel]] {
        do {
            let realm = try Realm()
            let habits = realm.objects(HabitsModel.self)
            
            return habits.map { habit in
                let sortedCells = habit.cells.sorted(byKeyPath: "timestamp", ascending: true)
                return sortedCells.map { habitCell in
                    return HabitCellModel(state: HabitCellModel.State.convertFromRealmStateType(habitCell.stateType, number: habitCell.stateNumber, percentage: habitCell.percentage))
                }
            }
        } catch {
            print("Ошибка загрузки привычек из Realm: \(error)")
            return []
        }
    }
    
    // Сохраняет или обновляет привычки в базе данных, используя транзакции Realm
    func saveHabitsToRealm(habitsModel: HabitsModel) {
        do {
            let realm = try Realm()
            try realm.write {
                if let existingHabit = realm.object(ofType: HabitsModel.self, forPrimaryKey: habitsModel.id) {
                    existingHabit.counter = habitsModel.counter
                    // Дополнительные обновления других свойств по необходимости
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
    
    // Добавляет новую функцию для сохранения состояния ячейки привычки
    func saveHabitCellState(_ habitCell: HabitCell) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(habitCell, update: .modified)
                print("Successfully saved cell with stateType: \(habitCell.stateType), stateNumber: \(habitCell.stateNumber)")
            }
        } catch {
            print("Error saving habit cell state: \(error)")
        }
    }
    
    // Загружает все объекты HabitsModel из базы данных в массив
    func loadAllHabitsFromRealm() -> [HabitsModel] {
        do {
            let realm = try Realm()
            return Array(realm.objects(HabitsModel.self))
        } catch {
            print("Error loading habits from Realm: \(error)")
            return []
        }
    }
    
    // Обновляет состояние ячейки в базе данных Realm
    func updateHabitCellStateAndPosition(id: ObjectId, newStateType: String, newStateNumber: Int) {
        do {
            let realm = try Realm()
            // Поиск объекта HabitCell по заданному идентификатору
            if let habitCell = realm.object(ofType: HabitCell.self, forPrimaryKey: id) {
                try realm.write {
                    habitCell.stateType = newStateType
                    habitCell.stateNumber = newStateNumber
                    habitCell.timestamp = Date()  // Обновляем временную метку
                }
                print("HabitCell с ID \(id) успешно обновлена.")
            } else {
                print("HabitCell с ID \(id) не найдена.")
            }
        } catch {
            print("Ошибка при обновлении HabitCell в Realm: \(error)")
        }
    }
}
    // Класс конфигурации приложения для сохранения и извлечения настроек
    final class ConfigurationStorage {
        enum StorageKeys: String {
            case dayCounter, lastModifiedDate, mainData
        }
        
        var dayCounter: Int? {
            get { return userDefaults.integer(forKey: StorageKeys.dayCounter.rawValue) }
            set { userDefaults.set(newValue, forKey: StorageKeys.dayCounter.rawValue) }
        }
        
        var lastModifiedDate: Date? {
            get { return userDefaults.object(forKey: StorageKeys.lastModifiedDate.rawValue) as? Date }
            set { userDefaults.set(newValue, forKey: StorageKeys.lastModifiedDate.rawValue) }
        }
        
        var mainData: [[String: [[Int]]]] {
            get { return userDefaults.object(forKey: StorageKeys.mainData.rawValue) as? [[String: [[Int]]]] ?? [] }
            set { userDefaults.set(newValue, forKey: StorageKeys.mainData.rawValue) }
        }
        
        private let userDefaults: UserDefaults
        
        init(userDefaults: UserDefaults = UserDefaults.standard) {
            self.userDefaults = userDefaults
        }
    }

class ScreenCellsInfo: Object {
    @objc dynamic var id = 0
    @objc dynamic var cellCount = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
