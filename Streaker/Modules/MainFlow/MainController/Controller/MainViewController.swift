import UIKit
import SnapKit

class MainViewController: UIViewController {
    private var habitsCollectionViewControllers: [HabitsCollectionViewController] = []
    private var topBlurEffectView: UIVisualEffectView?
    private var bottomBlurEffectView: UIVisualEffectView?
    private var buttons: [CustomButton] = []
    private var habitsData: [[HabitCellModel]] = []
    private var safeAreaInsets: UIEdgeInsets = .zero
    private var alertController: UIAlertController?
    private var numberOfButtons = 4
    private var mainView = MainView()
    private let storage = ConfigurationStorage()
    private let customNavBar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
        view.backgroundColor = UIColor(hex: "#1C1C1E")
        createHabitsData(forNumberOfButtons: numberOfButtons)
        setupButtons(totalButtons: numberOfButtons)
        setupHabitsCollectionViewController()
        createBlurBackground(at: .top)
        createBlurBackground(at: .bottom)
        updateBlurBackgroundPositionAndSize()
        setupCustomNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        safeAreaInsets = view.safeAreaInsets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
                make.bottom.equalTo(view.snp.bottom)
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
extension MainViewController {
    
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
extension MainViewController {
    
    enum BlurPosition {
        case top, bottom
    }
    
    private func createBlurBackground(at position: BlurPosition) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        if position == .top {
            // For top blur effect (navigation bar)
            view.insertSubview(blurEffectView, at: 4)
            topBlurEffectView = blurEffectView
        } else {
            // For bottom blur effect (tab bar)
            view.insertSubview(blurEffectView, at: 4)
            bottomBlurEffectView = blurEffectView
        }
    }
    
    private func updateBlurBackgroundPositionAndSize() {
        // Update top blur effect view
        if let topBlurEffectView = topBlurEffectView {
            topBlurEffectView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalToSuperview()
                // Use the safe area's top anchor, which includes the status bar and navigation bar heights inherently
                make.bottom.equalTo(customNavBar.snp.bottom).offset(8)
            }
        }
        
        // Update bottom blur effect view
        if let referenceButton = buttons.first, let bottomBlurEffectView = bottomBlurEffectView {
            let buttonFrame = view.convert(referenceButton.frame, from: referenceButton.superview)
            let bottomPadding = view.bounds.height - buttonFrame.maxY
            let blurBackgroundHeight = bottomPadding + buttonFrame.height / 2
            
            bottomBlurEffectView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(blurBackgroundHeight)
            }
        }
    }
}

//MARK: Init View Controller
extension MainViewController {
    
    private func initViewController() {
        setupCustomNavigationBar()
        initButtons()
        initHeader()
    }
    
    private func setupCustomNavigationBar() {
        
        customNavBar.backgroundColor = .clear // Ваш кастомний колір
        view.addSubview(customNavBar)
        
        customNavBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(80) // Висота стандартного навігаційного бару
        }
        // Додавання кастомних кнопок на вашу кастомну навігаційну панель
        mainView.addButtonsToSuperview(customNavBar)
    }
    
    func initButtons() {
        // Налаштування дій для кнопок
        mainView.addButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        mainView.settingsButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        let baseScreenWidth: CGFloat = 375 // Width of iPhone SE screen
        let scaleFactor = view.bounds.width / baseScreenWidth
        let buttonWidth: CGFloat = 74 * scaleFactor
        let buttonHeight: CGFloat = 54 * scaleFactor
        let buttonSpacing: CGFloat = 16 * scaleFactor
        
        mainView.addButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(buttonSpacing)
            make.centerY.equalToSuperview()
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        mainView.settingsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-buttonSpacing)
            make.centerY.equalToSuperview()
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
    }
    
    func initHeader() {
        // Налаштування заголовка, якщо ви не використовуєте стандартний navigationBar
        let titleLabel = UILabel()
        titleLabel.text = "День \(storage.dayCounter ?? 0)"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.sizeToFit()
        
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        titleLabel.center = CGPoint(x: titleView.bounds.midX, y: titleView.bounds.midY)
        customNavBar.addSubview(titleView)
        
        titleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func leftButtonTapped() {
        let settingsVC = StatsViewController()
        settingsVC.navigationItem.hidesBackButton = false
        settingsVC.navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func rightButtonTapped() {
        let settingsVC = ProfileViewController()
        settingsVC.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
}