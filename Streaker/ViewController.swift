import UIKit
import SnapKit

class ViewController: UIViewController {
    private var habitsCollectionViewControllers: [HabitsCollectionViewController] = []
    private var blurEffectView: UIVisualEffectView?
    private var buttons: [CustomButton] = []
    private var habitsData: [[HabitCellModel]] = []
    private var safeAreaInsets: UIEdgeInsets = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#1C1C1E")
        let numberOfButtons = 4 // Это число будет определяться динамически в будущем
        createHabitsData(forNumberOfButtons: numberOfButtons)
        setupButtons(totalButtons: numberOfButtons) // Определения количества кнопок
        setupHabitsCollectionViewController()
        createBlurBackground()
        updateBlurBackgroundPositionAndSize()
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            // Обновляем переменную safeAreaInsets
            safeAreaInsets = view.safeAreaInsets
        }
    
    private func createHabitsData(forNumberOfButtons count: Int) {
        habitsData = Array(repeating: [], count: count)
        for index in 0..<count {
            habitsData[index] = loadInitialDataForButton(at: index)
        }
    }
    
    private func loadInitialDataForButton(at index: Int) -> [HabitCellModel] {
        return Array(repeating: HabitCellModel(state: .emptyCell), count: cellsInAvailableHeight)
    }
    
    private func setupButtons(totalButtons: Int) {
        for index in 0..<totalButtons {
            let button = CustomButton()
            button.scaleButtonElements(forScreenWidth: view.bounds.width)
            button.setPositionAtBottomCenter(in: view, index: index, totalButtons: totalButtons)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            //view.addSubview(button)
            button.layer.zPosition = 2
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
        updateColumns()
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
            let insets = UIEdgeInsets(top: actualButtonHeight, left: 0, bottom: 0, right: 0)
            habitsVC.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            habitsVC.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            habitsVC.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            habitsVC.collectionView.contentInset = insets
            habitsVC.collectionView.scrollIndicatorInsets = insets
            self.view.sendSubviewToBack(habitsVC.view)
            habitsVC.view.layer.zPosition = 0
            
            if let firstButton = buttons.first {
                habitsVC.buttonSize = firstButton.bounds.size // Передаем размеры кнопки
            }
            
            habitsVC.view.snp.makeConstraints { make in
                make.width.equalTo(button.snp.width).offset(18) // 18 adding scroll area between columns
                make.centerX.equalTo(button.snp.centerX)
                make.top.equalTo(view.snp.top)
                //make.bottom.equalTo(button.snp.top) // .offset(32) уменьшает отступ от кнопок
                make.bottom.equalTo(view.snp.bottom)
                //make.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom)
            }
        }
    }
    
    lazy var actualButtonHeight: CGFloat = {
        let baseScreenWidth: CGFloat = 375 // Width of iPhone SE screen
        let scaleFactor = UIScreen.main.bounds.width / baseScreenWidth
        let buttonHeight: CGFloat = 74 * scaleFactor
        return buttonHeight
    }()
    
    lazy var cellsInAvailableHeight: Int = {
        let baseScreenWidth: CGFloat = 375
        let scaleFactor = UIScreen.main.bounds.width / baseScreenWidth
        let buttonHeight: CGFloat = 74 * scaleFactor
        let cellHeight = buttonHeight + (buttonHeight * 0.216)
        let labelHeight: CGFloat = 16 // Фиксированная высота лейбла
        let bottomPadding: CGFloat = 32 // 48 - 16 label
        let totalHeightOfButtonsAndLabels = buttonHeight + labelHeight + bottomPadding
        let availableHeight = view.frame.height - totalHeightOfButtonsAndLabels
        return Int(floor(availableHeight / cellHeight))
    }()
}

// MARK: - Align Columns Height
extension ViewController {
    
    private func maxFilledCellsCount() -> Int {
        return habitsData.map { $0.filter { $0.state != .emptyCell }.count }.max() ?? 0
    }
    
    private func updateColumns() {
        let maxFilledCellsCount = habitsData.map { $0.filter { $0.state != .emptyCell }.count }.max() ?? 0
        
        if maxFilledCellsCount > cellsInAvailableHeight {
            for index in 0..<habitsData.count {
                let filledCellsCount = habitsData[index].filter { $0.state != .emptyCell }.count
                let additionalCellsCount = maxFilledCellsCount - filledCellsCount
                if additionalCellsCount > 0 {
                    // Очищаем пустые ячейки перед добавлением новых, чтобы избежать накопления
                    habitsData[index].removeAll(where: { $0.state == .emptyCell })
                    habitsData[index].append(contentsOf: Array(repeating: HabitCellModel(state: .emptyCell), count: additionalCellsCount))
                }
                
                let habitsVC = habitsCollectionViewControllers[index]
                habitsVC.cellModels = habitsData[index]
                habitsVC.collectionView.reloadData()
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
            view.insertSubview(blurEffectView, at: 4) //Move blur layer above cells
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
