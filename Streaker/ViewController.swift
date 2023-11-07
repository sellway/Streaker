

import UIKit
import SnapKit

class ViewController: UIViewController {
    private var buttons: [CustomButton] = []
    private var blurEffectView: UIVisualEffectView?
    private var habitsCollectionViewController: HabitsCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
        createBlurBackground()
        setupButtons()
        if let firstButton = buttons.first {
                setupHabitsCollectionViewController(above: firstButton) // Теперь настраиваем HabitsCollectionViewController
            }
    }
    
    private func setupButtons() {
        let totalButtons = 4
        for index in 0..<totalButtons {
            let button = CustomButton()
            button.scaleButtonElements(forScreenWidth: view.bounds.width)
            button.setPositionAtBottomCenter(in: view, index: index, totalButtons: totalButtons)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            view.addSubview(button)
        }
        
        // Принудительное обновление layout, чтобы убедиться, что все кнопки находятся на своих местах
        view.layoutIfNeeded()
        
        // Теперь можно настроить HabitsCollectionViewController
            if let firstButton = buttons.first {
                setupHabitsCollectionViewController(above: firstButton)
            }
    }
    
    @objc private func buttonTapped(_ sender: CustomButton) {
        // Обновите данные в HabitsCollectionViewController в зависимости от нажатой кнопки
        // Например, измените cellModels или переключите на другой контроллер
    }
    
    private func setupHabitsCollectionViewController(above button: UIButton) {
        let habitsVC = HabitsCollectionViewController()
        self.addChild(habitsVC)
        self.view.addSubview(habitsVC.view)
        habitsVC.didMove(toParent: self)
        habitsCollectionViewController = habitsVC
        
        if let firstButton = buttons.first {
                    habitsVC.buttonSize = firstButton.bounds.size // Передаем размеры кнопки
                }
        
        // Устанавливаем ограничения для collectionView, чтобы он был над кнопками
        habitsVC.view.snp.makeConstraints { make in
                make.width.equalTo(button.snp.width) // Ширина collectionView равна ширине кнопки
                make.centerX.equalTo(button.snp.centerX) // Центрируем collectionView относительно кнопки
                make.top.equalTo(view.snp.top) // Верхняя граница от safe area
                make.bottom.equalTo(button.snp.top) // Нижняя граница до верха кнопки
            }
    }
    
}



// MARK: - Blur Background Handling
extension ViewController {
    private func createBlurBackground() {
        // Блюр-подложка
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.translatesAutoresizingMaskIntoConstraints = false
        if let blurEffectView = blurEffectView {
            view.insertSubview(blurEffectView, at: 0)
        }
    }
    
    private func updateBlurBackgroundPositionAndSize() {
        if let referenceButton = buttons.first, let blurEffectView = blurEffectView {
            let buttonFrame = view.convert(referenceButton.frame, from: referenceButton.superview)
            let bottomPadding = view.bounds.height - buttonFrame.maxY
            let blurBackgroundHeight = bottomPadding + buttonFrame.height / 2
            
            blurEffectView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(blurBackgroundHeight)
            }
        }
    }
}
