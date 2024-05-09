/*

Этот код:
1 - Расширяет `UIColor`, добавляя перечисление `ColorType` для различных пользовательских цветов.
2 - Добавляет метод `theme(_:)`, который возвращает цвет на основе типа из `ColorType`.
3 - Использует `UIColor(named:)` для поиска цветов в ресурсах приложения по имени и вызывает `fatalError`, если цвет не найден.

*/

import Foundation

import Foundation
import UIKit

extension UIColor {
    enum ColorType {
        case streakerGrey
      
    }
    
    static func theme(_ colorType: ColorType) -> UIColor {
        var color: UIColor?
        
        switch colorType {
        case .streakerGrey:
            color = UIColor(named: "streakerGrey")
        }
        
        guard let color = color else {
            fatalError("Color \(colorType) not found")
        }
        
        return color
    }
}
