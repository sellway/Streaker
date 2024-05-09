/*
Этот класс `RootNavigationViewController`:

1. Создает корневой `UINavigationController` с `MainViewController` в качестве начального контроллера.
2. Настраивает внешний вид навигационной панели с помощью `UINavigationBarAppearance`, добавляя прозрачный фон, эффект размытия и белый цвет текста.
3. Скрывает навигационную панель, устанавливая свойство `isNavigationBarHidden` в `false`.
*/

import Foundation
import UIKit

class RootNavigationViewController: UINavigationController {
    init() {
        let mainScreenVC = MainViewController()
        super.init(rootViewController: mainScreenVC)
        isNavigationBarHidden = false
        setupNavigationBarAppearance()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor.clear
        appearance.backgroundImage = UIImage()
        
        appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
