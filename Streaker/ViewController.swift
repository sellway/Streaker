

import UIKit
import SnapKit

class ViewController: UIViewController {
    private var buttons: [CustomButton] = []
    private var blurEffectView: UIVisualEffectView?
    private var habitsCollectionViewControllers: [HabitsCollectionViewController] = []
    private var habitsData: [[HabitCellModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#1C1C1E")
        createBlurBackground()
        let numberOfButtons = 4 // Это число будет определяться динамически в будущем
        createHabitsData(forNumberOfButtons: numberOfButtons)
        setupButtons(totalButtons: numberOfButtons) // Используйте параметр для определения количества кнопок
        setupHabitsCollectionViewController()
    }
    
    private func createHabitsData(forNumberOfButtons count: Int) {
        habitsData = Array(repeating: [], count: count)
        for index in 0..<count {
            habitsData[index] = loadInitialDataForButton(at: index)
        }
    }
    
    private func loadInitialDataForButton(at index: Int) -> [HabitCellModel] {
        return Array(repeating: HabitCellModel(state: .emptyCell), count: 9)
    }
    
    
    private func setupButtons(totalButtons: Int) {
        for index in 0..<totalButtons {
            let button = CustomButton()
            button.scaleButtonElements(forScreenWidth: view.bounds.width)
            button.setPositionAtBottomCenter(in: view, index: index, totalButtons: totalButtons)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            view.addSubview(button)
        }
        
        view.layoutIfNeeded()
    }
    
    @objc private func buttonTapped(_ sender: CustomButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else { return }
        let newModels = loadNewDataForButton(at: buttonIndex)
        habitsData[buttonIndex] = newModels
        let habitsVC = habitsCollectionViewControllers[buttonIndex]
        habitsVC.cellModels = newModels
        habitsVC.collectionView.reloadData()
    }
    
    private func loadNewDataForButton(at index: Int) -> [HabitCellModel] {
        // Получаем текущие модели данных для кнопки
        var currentCellModels = habitsData[index]
        
        // Проверяем, есть ли пустые клетки
        if let emptyCellIndex = currentCellModels.firstIndex(where: { $0.state == .emptyCell }) {
            // Заменяем первую пустую клетку на новую модель
            currentCellModels[emptyCellIndex] = HabitCellModel(state: .completedWithNoLine) // или другое состояние, которое вы хотите использовать
        } else {
            // Если пустых клеток нет, добавляем новую модель в конец
            currentCellModels.append(HabitCellModel(state: .completedWithNoLine)) // или другое состояние
        }
        
        // Возвращаем обновленный массив моделей
        return currentCellModels
    }
    
    
    
    private func setupHabitsCollectionViewController() {
        for (index, button) in buttons.enumerated() {
            let habitsVC = HabitsCollectionViewController()
            self.addChild(habitsVC)
            self.view.addSubview(habitsVC.view)
            habitsVC.didMove(toParent: self)
            habitsCollectionViewControllers.append(habitsVC)
            habitsVC.cellModels = habitsData[index]
            
            if let firstButton = buttons.first {
                habitsVC.buttonSize = firstButton.bounds.size // Передаем размеры кнопки
            }
            
            habitsVC.view.snp.makeConstraints { make in
                make.width.equalTo(button.snp.width)
                make.centerX.equalTo(button.snp.centerX)
                make.top.equalTo(view.snp.top)
                make.bottom.equalTo(button.snp.top)
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
