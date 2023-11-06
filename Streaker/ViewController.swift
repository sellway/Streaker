

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
        setupHabitsCollectionViewController()
        setupButtons()
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
        
        // После того, как все кнопки созданы и добавлены в массив, передайте размеры в HabitsCollectionViewController
        if let habitsVC = habitsCollectionViewController, let firstButton = buttons.first {
            habitsVC.buttonSize = firstButton.buttonSize
            habitsVC.collectionView.reloadData() // Обновите collectionView с новыми размерами
        }
    }
    
    @objc private func buttonTapped(_ sender: CustomButton) {
        // Обновите данные в HabitsCollectionViewController в зависимости от нажатой кнопки
        // Например, измените cellModels или переключите на другой контроллер
    }
    
    private func setupHabitsCollectionViewController() {
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
            make.top.leading.trailing.equalToSuperview()
            // Здесь мы устанавливаем нижнее ограничение относительно верхней части кнопок
            // Предполагая, что у вас есть ссылка на самую нижнюю кнопку или их контейнер
            if let firstButton = buttons.first {
                make.bottom.leading.trailing.equalTo(firstButton.snp.top)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
