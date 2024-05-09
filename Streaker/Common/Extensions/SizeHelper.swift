/*

Этот код:
1 - Добавляет расширения для числовых типов `BinaryFloatingPoint` и `BinaryInteger`.
2 - Обеспечивает удобные вычисления относительных размеров для ширины (`sizeW`) и высоты (`sizeH`), масштабируемых в соответствии с текущим экраном.
3 - Реализует логику условной масштабируемости с методами `lessThanOrEqualToSizeW` и `lessThanOrEqualToSizeH`, которые возвращают либо масштабированное значение, либо оригинальное значение.

*/

import Foundation
import UIKit

extension BinaryFloatingPoint {
    private var size: CGSize {
        return CGSize(width: 375, height: 812)
    }
    
    /// iPhone Template: 414 x 896
    var sizeW: CGFloat {
        (CGFloat(self) * UIScreen.main.bounds.width / size.width).rounded(toPlaces: 0)
    }
    
    /// iPhone Template: 414 x 896
    var sizeH: CGFloat {
        (CGFloat(self) * UIScreen.main.bounds.height / size.height).rounded(toPlaces: 0)
    }
    
    /// iPhone Template: 414 x 896
    var lessThanOrEqualToSizeW: CGFloat {
        UIScreen.main.bounds.width < size.width ? self.sizeW : CGFloat(self)
    }
    
    /// iPhone Template: 414 x 896
    var lessThanOrEqualToSizeH: CGFloat {
        UIScreen.main.bounds.height < size.height ? self.sizeH : CGFloat(self)
    }
}

extension BinaryInteger {
    /// iPhone Template: 414 x 896
    var sizeW: CGFloat {
        CGFloat(self).sizeW
    }
    
    /// iPhone Template: 414 x 896
    var sizeH: CGFloat {
        CGFloat(self).sizeH
    }
    
    /// iPhone Template: 414 x 896
    var lessThanOrEqualToSizeW: CGFloat {
        CGFloat(self).lessThanOrEqualToSizeW
    }
    
    /// iPhone Template: 414 x 896
    var lessThanOrEqualToSizeH: CGFloat {
        CGFloat(self).lessThanOrEqualToSizeH
    }
}
