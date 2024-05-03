
import UIKit
//import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootNavigationViewController()
        window?.makeKeyAndVisible()
        
        let configStorage = ConfigurationStorage()
        
        // Проверка, было ли последнее изменение сделано сегодня
        if let lastDate = configStorage.lastModifiedDate, Calendar.current.isDateInToday(lastDate) {
            // Если последняя модификация была сегодня, дополнительных действий не требуется
        } else {
            // Обновляем счётчик дней и устанавливаем текущую дату как последнюю дату модификации
            let currentDayCounter = configStorage.dayCounter ?? 0
            configStorage.dayCounter = currentDayCounter + 1
            configStorage.lastModifiedDate = Date()
        }

        // Очистка всех данных Realm при каждом запуске приложения
        //deleteAllFromRealm()
        
        return true
    }
    
//    func deleteAllFromRealm() {
//        do {
//            let realm = try Realm()
//            try realm.write {
//                realm.deleteAll()
//            }
//            print("All data deleted from Realm.")
//        } catch let error as NSError {
//            print("Error deleting data from Realm: \(error.localizedDescription)")
//        }
//    }
}
