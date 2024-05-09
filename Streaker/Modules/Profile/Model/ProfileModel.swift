/*

Этот enum `ProfileModel`:
1 - Содержит кейсы для различных элементов профиля, таких как "новая привычка", "мои привычки", и т. д.
2 - Предоставляет локализованные заголовки для каждого элемента через свойство `title`.
3 - Возвращает соответствующую изображению иконку для каждого элемента через свойство `image`.

*/

import Foundation
import UIKit.UIImage

enum ProfileModel: CaseIterable {
    case newStreak
    case myStreaks
    case howItWorks
    case pauseAll
    case sendFeadback
    case settings
    
    var title: String {
        switch self {
       
        case .newStreak:
            return "add_new_st".localized()
        case .myStreaks:
            return "my_streaks".localized()
        case .howItWorks:
            return "how_it_works".localized()
        case .pauseAll:
            return "pause_all".localized()
        case .sendFeadback:
            return "send_Feadback".localized()
        case .settings:
            return "settings".localized()
        }
    }
    
    var image: UIImage {
        switch self {
      
        case .newStreak:
            return .theme(.newStrake)
        case .myStreaks:
            return .theme(.myStreake)
        case .howItWorks:
            return .theme(.howItWorks)
        case .pauseAll:
            return .theme(.pauseAll)
        case .sendFeadback:
            return .theme(.sendFeadback)
        case .settings:
            return .theme(.settings)
        }
    }
}
