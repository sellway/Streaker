

import UIKit
import SnapKit

class ViewController: UIViewController {
    private var buttons: [CustomButton] = []
    private var blurEffectView: UIVisualEffectView?
    private var habitsCollectionViewControllers: [HabitsCollectionViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
        createBlurBackground()
        setupButtons()
        setupHabitsCollectionViewController()
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
    }
    
    @objc private func buttonTapped(_ sender: CustomButton) {
        // Обновите данные в HabitsCollectionViewController в зависимости от нажатой кнопки
        // Например, измените cellModels или переключите на другой контроллер
    }
    
    private func setupHabitsCollectionViewController() {
        for button in buttons {
            let habitsVC = HabitsCollectionViewController()
            self.addChild(habitsVC)
            self.view.addSubview(habitsVC.view)
            habitsVC.didMove(toParent: self)
            habitsCollectionViewControllers.append(habitsVC)
            
            if let firstButton = buttons.first {
                habitsVC.buttonSize = firstButton.bounds.size // Передаем размеры кнопки
            }
            
            // Устанавливаем ограничения для collectionView, чтобы он был над кнопками
            habitsVC.view.snp.makeConstraints { make in
                make.width.equalTo(button.snp.width)
                make.centerX.equalTo(button.snp.centerX)
                make.top.equalToSuperview() // Используйте эту строку, если вы хотите, чтобы верхняя часть collectionView была прикреплена к верхней части супервью
                make.bottom.equalTo(button.snp.top) // Это ограничение прикрепляет нижнюю часть collectionView к верхней части кнопки
            }
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
