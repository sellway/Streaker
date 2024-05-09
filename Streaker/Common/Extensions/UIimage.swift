/*
Этот код:
1. Добавляет расширение для `UIImage`, создавая перечисление `imageType`, в котором хранится набор типов изображений, используемых в приложении.
2. Определяет метод `theme(_:)`, возвращающий изображения по их типу из перечисления. Например, для `.newStrake` загружается изображение "profile1".
3. Использует `fatalError`, если соответствующее изображение не найдено, чтобы избежать сбоев при загрузке отсутствующих ресурсов.
*/

import Foundation
import UIKit

extension UIImage {
    enum imageType {
        
        case newStrake
        case myStreake
        case howItWorks
        case pauseAll
        case sendFeadback
        case settings
        
        case esential
        case Morning
        case beter
        case healthy
        case Happines
        case stay
        case Learn
        case personal
        case relationShip
        case plus
    }
    
    static func theme(_ imageType: imageType) -> UIImage {
        var image: UIImage?
        
        switch imageType {
        case .newStrake:
            image = UIImage(named: "profile1")
        case .myStreake:
            image = UIImage(named: "profile2")
        case .howItWorks:
            image = UIImage(named: "profile3")
        case .pauseAll:
            image = UIImage(named: "profile4")
        case .sendFeadback:
            image = UIImage(named: "profile5")
        case .settings:
            image = UIImage(named: "profile6")
        case .esential:
            image = UIImage(named: "new1")
        case .Morning:
            image = UIImage(named: "new2")
        case .beter:
            image = UIImage(named: "new3")
        case .healthy:
            image = UIImage(named: "new4")
        case .Happines:
            image = UIImage(named: "new5")
        case .stay:
            image = UIImage(named: "new6")
        case .Learn:
            image = UIImage(named: "new7")
        case .personal:
            image = UIImage(named: "new8")
        case .relationShip:
            image = UIImage(named: "new9")
        case .plus:
            image = UIImage(named: "plus")
        }
        
        // TODO: remove before project publish
        guard let image = image else {
            fatalError("Color \(imageType) not found")
        }
        
        return image
    }
}
