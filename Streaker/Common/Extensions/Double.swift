/*

Этот код:
1. Добавляет расширение для типа `Double`.
2. Предоставляет метод `rounded(toPlaces:)`, позволяющий округлять значения типа `Double` до определенного количества десятичных знаков.
3. Возвращает округленное значение в виде `CGFloat`.

*/

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
