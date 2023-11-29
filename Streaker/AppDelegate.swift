//
//  AppDelegate.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 30/10/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootNavigationViewController()
        window?.makeKeyAndVisible()
        
        let configStorage = ConfigurationStorage()
        
        if let lastDate = configStorage.lastModifiedDate, Calendar.current.isDateInToday(lastDate) {
        } else {
            // Если последняя модификация была не сегодня, обновляем dayCounter и сохраняем новую дату
            let currentDayCounter = configStorage.dayCounter ?? 0
            configStorage.dayCounter = currentDayCounter + 1
            configStorage.lastModifiedDate = Date()
        }
        
        return true
    }
}
