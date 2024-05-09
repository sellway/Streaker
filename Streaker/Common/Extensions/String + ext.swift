/*

Этот код:
1 - Расширяет `String`, добавляя метод `localized(bundle:tableName:)` для получения локализованного значения строки.
2 - Использует `NSLocalizedString` для извлечения перевода из файлов локализации.
3 - По умолчанию ищет в основном бандле (`.main`) и в файле `Localizable.strings`.

*/

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, comment: "")
    }
}
