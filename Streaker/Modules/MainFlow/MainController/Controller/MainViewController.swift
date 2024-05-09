/*
 
 Этот класс MainViewController:
 1 - Инициализирует и настраивает кнопки, коллекционные представления и другие элементы пользовательского интерфейса.
 2 - Загружает данные привычек из базы данных Realm и обновляет интерфейс в соответствии с этими данными.
 3 - Реагирует на действия пользователя, такие как нажатия на кнопки, и обновляет данные и представления.
 4 - Поддерживает синхронизацию прокрутки между различными коллекционными представлениями, управляемыми экземплярами HabitsCollectionViewController.
 */

import UIKit
import SnapKit
import RealmSwift

class MainViewController: UIViewController {
    // Lazy property that counts the number of HabitModel objects stored in Realm
    lazy var savedRecordsCount: Int = try! Realm().objects(HabitsModel.self).count
    // Collection of habits from Realm
    var habits: Results<HabitsModel>?
    // Custom buttons placed at the bottom of the screen
    var buttons: [CustomButton] = []
    // Array to hold the collection view controllers that display the habits
    private var habitsCollectionViewControllers: [HabitsCollectionViewController] = []
    // An array of arrays holding the cell models for each habit
    private var habitsData: [[HabitCellModel]] = []
    // Dynamically calculates the number of buttons based on the count of saved records
    private lazy var numberOfButtons: Int = savedRecordsCount
    // The view that contains custom buttons for adding habits and opening settings
    private var mainView = MainView()
    // Object for accessing app configurations stored in UserDefaults
    private let storage = ConfigurationStorage()
    // A custom navigation bar view
    private let customNavBar = UIView()
    // An array to keep track of the number of cells for each habit
    private var cellCounters: [Int] = []
    // Model to manage the main logic for the habits
    var mainModel: MainModel!
    // The view's safe area insets, useful for layout adjustment and blur effects
    private var safeAreaInsets: UIEdgeInsets = .zero
    private var alertController: UIAlertController?
    private var topBlurEffectView: UIVisualEffectView?
    private var bottomBlurEffectView: UIVisualEffectView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
        habits = loadHabits()
        habitsData = HabitsDataManager.shared.loadHabitsData()
        createBlurBackground(at: .top)
        createBlurBackground(at: .bottom)
        setupButtons(totalButtons: numberOfButtons)
        setupHabitsCollectionViewController()
        updateBlurBackgroundPositionAndSize()
        setupCustomNavigationBar()
        cellCounters = Array(repeating: 0, count: numberOfButtons)
        mainModel = MainModel(numberOfButtons: numberOfButtons, cellsPerButton: cellsInAvailableHeight)
        if let loadedHabits = loadHabits() {
            habits = loadedHabits
            habitsData = loadedHabits.map { habit in
                return Array(repeating: HabitCellModel(state: .completedWithNoLine(counter: habit.counter)), count: cellsInAvailableHeight)
            }
        }
        view.backgroundColor = UIColor(hex: "#1C1C1E")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("CollectionView did scroll: \(scrollView.contentOffset)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        // Update habits and UI to show created and don't show deleted habits
        habits = loadHabits()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Loads the persisted habits from Realm database and returns them
    private func loadHabits() -> Results<HabitsModel>? {
        do {
            let realm = try Realm()
            let habits = realm.objects(HabitsModel.self)
            print("Loaded \(habits.count) habits")
            for habit in habits {
                print("Habit: \(habit.name), counter: \(habit.counter)")
            }
            return habits
        } catch {
            print("Error loading habits from Realm: \(error)")
            return nil
        }
    }
    
    // Sets up the button data initially loaded for each habit, forming an array of habit cell models
    private func loadInitialDataForButton(at index: Int) -> [HabitCellModel] {
        // Здесь используем актуальное значение счетчика из объекта привычки
        if let habit = habits?[index] {
            // Если привычка существует, создаем массив моделей ячеек с состоянием completedWithNoLine и заданным счетчиком
            return Array(repeating: HabitCellModel(state: .completedWithNoLine(counter: habit.counter)), count: cellsInAvailableHeight)
        } else {
            // Если данные отсутствуют, возвращаем массив пустых ячеек
            return Array(repeating: HabitCellModel(state: .emptyCell), count: cellsInAvailableHeight)
        }
    }
    
    // Initializes and configures buttons based on the total number of habits, and adds them to the view
    private func setupButtons(totalButtons: Int) {
        // Очищаем существующие данные и кнопки перед их созданием
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        habitsData = Array(repeating: [], count: totalButtons)
        
        for index in 0..<totalButtons {
            // Создаем кнопку
            let button = CustomButton()
            if let habit = habits?[index] {
                button.labelBelowButton.updateText(with: habit.name, isOn: false)
                button.habitName = habit.name
            }
            button.scaleButtonElements(forScreenWidth: view.bounds.width)
            button.setPositionAtBottomCenter(in: view, index: index, totalButtons: totalButtons)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            
            // Создаем данные для кнопки
            habitsData[index] = loadInitialDataForButton(at: index)
        }
        
        // Перерисовываем интерфейс, чтобы убедиться, что кнопки отображаются корректно
        view.layoutIfNeeded()
        
        // Обновляем представления коллекции с новыми данными
        updateCollectionViews()
    }
    
    
    // Action handler for when a button is tapped; updates habit data and refreshes the collection views
    @objc private func buttonTapped(_ sender: CustomButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender),
              let habitToUpdate = habits?[buttonIndex] else { return }
        mainModel.updateHabitData(forButtonIndex: buttonIndex)
        do {
            let realm = try Realm()
            try realm.write {
                habitToUpdate.counter += 1
                print("Increased counter for habit: \(habitToUpdate.name) to \(habitToUpdate.counter)")
                
                // Найдите и обновите все связанные ячейки привычки
                let habitCells = habitToUpdate.cells.sorted(byKeyPath: "position", ascending: true)
                for (index, cell) in habitCells.enumerated() {
                    cell.stateNumber = habitToUpdate.counter + index
                    HabitsDataManager.shared.saveHabitCellState(cell)
                }
            }
            
            // Обновите данные коллекционных представлений
            habitsData[buttonIndex] = loadInitialDataForButton(at: buttonIndex)
        } catch {
            print("Error updating habit counter in Realm: \(error)")
        }
        mainModel.alignCellRows()
        updateCollectionViews()
    }

    
    // Updates the user interface by removing old components and setting up new ones based on the current data
    private func updateUI() {
        // Удаление старых кнопок
        buttons.forEach {
            $0.labelBelowButton.removeFromSuperview() // Удалить лейбл из superview
            $0.removeFromSuperview()
        }
        buttons.removeAll()
        
        // Удаление старых habitsCollectionViewControllers
        habitsCollectionViewControllers.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        habitsCollectionViewControllers.removeAll()
        
        // Обновление данных для UI
        numberOfButtons = habits?.count ?? 0
        mainModel = MainModel(numberOfButtons: numberOfButtons, cellsPerButton: cellsInAvailableHeight)
        
        // Инициализация и настройка кнопок
        setupButtons(totalButtons: numberOfButtons)
        setupHabitsCollectionViewController()
        updateCollectionViews()
    }
    
    // Refreshes the cells in all collection views to reflect any changes in the data model
    private func updateCollectionViews() {
        for (index, habitsVC) in habitsCollectionViewControllers.enumerated() {
            habitsVC.cellModels = mainModel.habitsData[index]
            DispatchQueue.main.async {
                habitsVC.collectionView.reloadData()
            }
        }
    }
    
    // Initializes and configures the collection view controllers for displaying habits
    private func setupHabitsCollectionViewController() {
        // Iterate through each button which represents a habit
        for (index, button) in buttons.enumerated() {
            // Create a new HabitsCollectionViewController for each habit
            let habitsVC = HabitsCollectionViewController()
            // Initialize the model for the view controller. This is where the habit data would be passed to the view controller
            habitsVC.habitsModel = HabitsModel()
            // Add the new collection view controller as a child to the current view controller
            self.addChild(habitsVC)
            // Add the collection view as a subview to the main view controller's view
            self.view.addSubview(habitsVC.view)
            // Notify the collection view controller that it has moved to the current parent view controller
            habitsVC.didMove(toParent: self)
            // Store the reference to the collection view controller in an array for later use
            habitsCollectionViewControllers.append(habitsVC)
            // Assign the cell models for this particular habit to the collection view controller
            habitsVC.cellModels = habitsData[index]
            // Set the collection view's scrolling behavior
            habitsVC.collectionView.contentInsetAdjustmentBehavior = .never
            // Set the initial content offset for the collection view
            habitsVC.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            // Set the insets for the collection view to adjust its scrollable area
            habitsVC.collectionView.contentInset = UIEdgeInsets(top: actualButtonHeight, left: 0, bottom: 0, right: 0)
            // Set the insets for the scroll indicators of the collection view
            habitsVC.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            // Place the collection view behind other subviews in the main view
            self.view.sendSubviewToBack(habitsVC.view)
            // Set the layer position of the view to the bottom
            habitsVC.view.layer.zPosition = 0
            // If there is at least one button, pass its size to the collection view controller.
            if let firstButton = buttons.first {
                habitsVC.buttonSize = firstButton.bounds.size
            }
            // Use SnapKit to make layout constraints for the collection view.
            habitsVC.view.snp.makeConstraints { make in
                make.width.equalTo(button.snp.width).offset(18)
                make.centerX.equalTo(button.snp.centerX)
                make.top.bottom.equalToSuperview()
            }
        }
    }
    
    // Calculates the number of cells that can fit in the available screen height
    lazy var cellsInAvailableHeight: Int = {
        let baseScreenWidth: CGFloat = 375
        let scaleFactor = UIScreen.main.bounds.width / baseScreenWidth
        let buttonHeight: CGFloat = 74 * scaleFactor
        let cellHeight = buttonHeight + (buttonHeight * 0.200)
        let labelHeight: CGFloat = 16
        let bottomPadding: CGFloat = 32
        let totalHeightOfButtonsAndLabels = buttonHeight + labelHeight + bottomPadding
        let availableHeight = view.safeAreaLayoutGuide.layoutFrame.height - totalHeightOfButtonsAndLabels
        let calculatedCells = Int(floor(availableHeight / cellHeight))
        return calculatedCells
    }()
    
    // Calculates the height of the actual button area, taking into account various UI components and padding
    lazy var actualButtonHeight: CGFloat = {
        let baseScreenWidth: CGFloat = 375
        let scaleFactor = UIScreen.main.bounds.width / baseScreenWidth
        let buttonHeight: CGFloat = 74 * scaleFactor
        print("buttonHeight:\(buttonHeight)")
        let labelHeight: CGFloat = 16
        let bottomPadding: CGFloat = 32
        let totalHeightOfButtonsAndLabels = buttonHeight + labelHeight + bottomPadding
        return totalHeightOfButtonsAndLabels
    }()
}

// MARK: - Align Columns Height
//extension MainViewController {
//
//    private func maxFilledCellsCount() -> Int {
//        return habitsData.map { $0.filter { $0.state != .emptyCell }.count }.max() ?? 0
//    }
//
//    // Ensures all columns in the collection view have the same number of cells, padding empty cells where necessary
//    private func updateColumns() {
//        let maxFilledCellsCount = habitsData.map { $0.filter { $0.state != .emptyCell }.count }.max() ?? 0 // макс количество заполненных ячеек среди всех кнопок
//
//        if maxFilledCellsCount > cellsInAvailableHeight {
//            for index in 0..<habitsData.count {
//                let filledCellsCount = habitsData[index].filter { $0.state != .emptyCell }.count
//                let additionalCellsCount = maxFilledCellsCount - filledCellsCount
//                if additionalCellsCount > 0 {
//                    // Очищаем пустые ячейки перед добавлением новых, чтобы избежать накопления
//                    habitsData[index].removeAll(where: { $0.state == .emptyCell })
//                    habitsData[index].append(contentsOf: Array(repeating: HabitCellModel(state: .emptyCell), count: additionalCellsCount))
//                }
//
//                let habitsVC = habitsCollectionViewControllers[index]
//                habitsVC.cellModels = habitsData[index]
//                habitsVC.collectionView.reloadData()
//            }
//        }
//    }
//}

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
    
    // Configures the header title view when not using the standard navigation bar
    func initHeader() {
        // Налаштування заголовка, якщо ви не використовуєте стандартний navigationBar
        let titleLabel = UILabel()
        titleLabel.text = "Day \(storage.dayCounter ?? 0)"
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
    
    // Action handlers for the custom left and right navigation buttons
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

//MARK: scrollViewDidEndDragging
extension HabitsCollectionViewController {
    // After a user stops scrolling the collection view, this method checks for empty cells and resets the scroll if necessary
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        checkForEmptyCellsAndResetScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkForEmptyCellsAndResetScroll(scrollView)
    }
    
    private func checkForEmptyCellsAndResetScroll(_ scrollView: UIScrollView) {
        // Проверяем, есть ли пустые клетки во всех колонках
        let allCollectionsHaveEmptyCells = HabitsCollectionViewController.synchronizedCollectionViews.allSatisfy { viewController in
            viewController.cellModels.contains { $0.state == .emptyCell }
        }
        // Если во всех колонках есть хотя бы одна пустая клетка, возвращаем скролл на начало
        if allCollectionsHaveEmptyCells {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                // Используем отступ сверху для возвращения скролла, так как предполагается инвертированный скролл
                let offset = CGPoint(x: 0, y: -layout.sectionInset.bottom)
                scrollView.setContentOffset(offset, animated: true)
            }
        }
    }
}
