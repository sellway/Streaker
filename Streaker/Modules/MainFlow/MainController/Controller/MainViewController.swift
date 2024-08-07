/*
 
 Инструкция для чата GPT:
 1 - Пиши только строки кода которые нужно вставить/заменить
 2 - Не пиши весь класс целиком
 3 - Не пиши функции целиком
 4 - Пиши строку после/вместо которой вставить текст в виде комментария //
 5 - Отвечай на вопросы коротко
 6 - Пиши код в формате было/стало при этом пиши только код который поменялся
 7 - Код который не поменялся писать не нужно
 
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
    lazy var savedRecordsCount: Int = {
        do {
            let realm = try Realm()
            return realm.objects(HabitsModel.self).count
        } catch {
            print("Error initializing Realm: \(error)")
            return 0
        }
    }()
    var scrollView: UIScrollView!
    var contentView: UIView!
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
    private var mainView = MainView()
    var containerView: UIView!
    // Object for accessing app configurations stored in UserDefaults
    private let storage = ConfigurationStorage()
    // A custom navigation bar view
    private let customNavController = CustomNavigationController()
    // An array to keep track of the number of cells for each habit
    private var cellCounters: [Int] = []
    // Model to manage the main logic for the habits
    var mainModel: MainModel!
    // The view's safe area insets, useful for layout adjustment and blur effects
    private var safeAreaInsets: UIEdgeInsets = .zero
    private var alertController: UIAlertController?
    private var bottomBlurEffectView: UIVisualEffectView?
    private var totalContentWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#1C1C1E")
        setupScrollView()
        setupContentView()
        setupHabitsCollectionViewController()
        createBottomBlur()
        setupButtons(totalButtons: numberOfButtons)
        initViewController()
        habits = loadHabits()
        habitsData = HabitsDataManager.shared.loadHabitsData()
        updateBlurBackgroundPositionAndSize()
        setupCustomNavigationBar()
        cellCounters = Array(repeating: 0, count: numberOfButtons)
        mainModel = MainModel(numberOfButtons: numberOfButtons, cellsPerButton: cellsInAvailableHeight)
        // Создаем и настраиваем MyStreaksViewController
        let myStreaksVC = MyStreaksViewController()
        myStreaksVC.mainViewController = self
        updateUI() // Обновление интерфейса с загруженными данными
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        habits = loadHabits()
        // Обновляем данные для каждой кнопки
        for i in 0..<buttons.count {
            habitsData[i] = loadInitialDataForButton(at: i)
        }
        updateCollectionViews()  // Обновляем представления для отражения новых данных
        reloadHabitsData() // Перезагружаем данные перед их использованием
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // Loads the persisted habits from Realm database and returns them
    private func loadHabits() -> Results<HabitsModel>? {
        do {
            let realm = try Realm()
            let habits = realm.objects(HabitsModel.self)
            print("Loaded \(habits.count) habits")
            
            return habits
        } catch {
            print("Error loading habits from Realm: \(error)")
            return nil
        }
    }
    
    func reloadHabitsData() {
        habits = loadHabits()
        // Проверяем каждую кнопку и обновляем данные
        for i in 0..<buttons.count {
            if i < habits?.count ?? 0 {
                habitsData[i] = loadInitialDataForButton(at: i)
            }
        }
        updateCollectionViews()  // Обновляем представления для отражения новых данных
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.isScrollEnabled = true
        scrollView.isDirectionalLockEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    private func setupContentView() {
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // Center horizontally
            make.edges.equalToSuperview() // Keep the edges equal to the scroll view
            make.height.equalToSuperview() // Match the height of the scroll view
            make.width.equalTo(totalContentWidth) // Set the width to the total content width
        }
    }
    
    private func maxCellsCount() -> Int {
        return habits?.map { $0.counter }.max() ?? 0
    }
    
    // Sets up the button data initially loaded for each habit, forming an array of habit cell models
    func loadInitialDataForButton(at index: Int) -> [HabitCellModel] {
        guard index < (habits?.count ?? 0), let habit = habits?[index] else {
            return []
        }
        let maxCells = maxCellsCount()
        if habit.counter > 0 {
            let completedCells = (1...habit.counter).map { HabitCellModel(state: .completedWithNoLine(counter: $0)) }
            let emptyCells = Array(repeating: HabitCellModel(state: .emptyCell), count: maxCells - habit.counter)
            return (completedCells.reversed() + emptyCells)
        } else {
            // Если данные отсутствуют или counter равен 0, возвращаем массив пустых ячеек согласно максимальному количеству
            return Array(repeating: HabitCellModel(state: .emptyCell), count: maxCells)
        }
    }
    
    
    // Initializes and configures buttons based on the total number of habits, and adds them to the view
    private func setupButtons(totalButtons: Int) {
        // Очищаем существующие данные и кнопки перед их созданием
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        habitsData = Array(repeating: [], count: totalButtons)
        
        //        if habitsData.isEmpty {
        //                habitsData = Array(repeating: [], count: totalButtons)
        //            }
        
        for index in 0..<totalButtons {
            // Создаем кнопку
            let button = CustomButton()
            if let habit = habits?[index] {
                button.labelBelowButton.updateText(with: habit.name, isOn: false)
                button.habitName = habit.name
                button.iconView.image = UIImage(named: habit.icon.whiteIconName())
                button.backgroundColor = UIColor(hex: habit.color)
            }
            button.setPosition(in: contentView, index: index, totalButtons: totalButtons)
            contentView.bringSubviewToFront(button)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.isUserInteractionEnabled = true
            buttons.append(button)
            
            // Устанавливаем z-позицию кнопки
            button.layer.zPosition = 1
            
            // Создаем данные для кнопки
            habitsData[index] = loadInitialDataForButton(at: index)
        }
        
        
        // Перерисовываем интерфейс, чтобы убедиться, что кнопки отображаются корректно
            contentView.layoutIfNeeded()

            // Вычисляем buttonSpacing
        let baseScreenWidth: CGFloat = 375 // Width of iPhone SE screen
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = screenWidth / baseScreenWidth
        let buttonSpacing: CGFloat = 16 * scaleFactor

            // Устанавливаем contentSize для scrollView
            let totalContentWidth = CGFloat(totalButtons) * (CustomButton.buttonSize.width + buttonSpacing) + buttonSpacing
            scrollView.contentSize = CGSize(width: totalContentWidth, height: scrollView.frame.height)
        if totalButtons <= 4 {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
        
        // Обновляем ширину contentView после изменения contentSize
            contentView.snp.updateConstraints { make in
                make.width.equalTo(totalContentWidth)
            }

            // Обновляем представления коллекции с новыми данными
            updateCollectionViews()
    }
    
    
    // Action handler for when a button is tapped; updates habit data and refreshes the collection views
    @objc private func buttonTapped(_ sender: CustomButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender),
              let habitToUpdate = habits?[buttonIndex] else { return }
        
        
        print("Button \(buttonIndex + 1) tapped") // Отладочный вывод
        
        do {
            let realm = try Realm()
            try realm.write {
                habitToUpdate.counter += 1  // Увеличиваем счетчик привычки
                realm.add(habitToUpdate, update: .modified)  // Сохраняем изменения в Realm
                
                // Обновляем UI
                updateCellState(for: buttonIndex, withNewCounter: habitToUpdate.counter)
                self.updateUI()
            }
        } catch {
            print("Error updating habit counter in Realm: \(error)")
        }
    }
    
    private func updateCellState(for buttonIndex: Int, withNewCounter counter: Int) {
        // Убедимся, что обновляем только новые данные
        let existingData = habitsData[buttonIndex]
        if existingData.count < counter {
            // Добавляем только недостающие элементы
            let newData = (existingData.count+1...counter).map {
                HabitCellModel(state: .completedWithNoLine(counter: $0))
            }
            habitsData[buttonIndex].insert(contentsOf: newData, at: 0)
        }
        updateCollectionViews()  // Обновляем коллекционное представление
        habitsCollectionViewControllers[buttonIndex].collectionView.reloadData()
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
    
    func updateCollectionViews() {
        for (index, habitsVC) in habitsCollectionViewControllers.enumerated() {
            habitsVC.cellModels = habitsData[index]
            DispatchQueue.main.async {
                habitsVC.collectionView.reloadData()
                self.contentView.sendSubviewToBack(habitsVC.view)
            }
        }
    }
    
    func deleteHabitFromUI(at indexPath: IndexPath) {
        guard indexPath.row < buttons.count else {
            print("Index out of range")
            return
        }
        
        do {
            let realm = try Realm()
            try realm.write {
                if let habit = habits?[indexPath.row], indexPath.row < habits?.count ?? 0 {
                    realm.delete(habit)
                    updateUI() // Вызовите обновление UI после изменения данных
                }
            }
        } catch let error as NSError {
            print("Ошибка удаления привычки: \(error.localizedDescription)")
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
            self.contentView.addSubview(habitsVC.view)
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
            // Устанавливаем z-позицию коллекции
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
        
        // Check and save to Realm
        let realm = try! Realm()
        if let storedInfo = realm.object(ofType: ScreenCellsInfo.self, forPrimaryKey: 0) {
            print("Loaded cell count from Realm: \(storedInfo.cellCount)")
            return storedInfo.cellCount
        } else {
            try! realm.write {
                let newInfo = ScreenCellsInfo()
                newInfo.cellCount = calculatedCells
                realm.add(newInfo, update: .modified)
            }
            print("Calculated and saved new cell count to Realm: \(calculatedCells)")
        }
        return calculatedCells
    }()
    
    let buttonSpacing: CGFloat = {
        let baseScreenWidth: CGFloat = 375
        let scaleFactor = UIScreen.main.bounds.width / baseScreenWidth
        return 16 * scaleFactor
    }()
    
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

// MARK: - Blur Background Handling
extension MainViewController {

    private func createBottomBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false

        // For bottom blur effect (tab bar)
        contentView.insertSubview(blurEffectView, at: 4)
        bottomBlurEffectView = blurEffectView
    }

    private func updateBlurBackgroundPositionAndSize() {
        // Update bottom blur effect view
        if let referenceButton = buttons.first, let bottomBlurEffectView = bottomBlurEffectView {
            let buttonFrame = contentView.convert(referenceButton.frame, from: referenceButton.superview)
            let bottomPadding = contentView.bounds.height - buttonFrame.maxY
            let blurBackgroundHeight = bottomPadding + buttonFrame.height / 2

            bottomBlurEffectView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(blurBackgroundHeight)
            }
        }
    }
}


// MARK: - Init View Controller
extension MainViewController {
    private func initViewController() {
        setupCustomNavigationBar()
        initButtons()
        initHeader()
    }

    private func setupCustomNavigationBar() {
        view.addSubview(customNavController.customNavBar)

        customNavController.customNavBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
                make.height.equalTo(72 + window.safeAreaInsets.top)
            }
        }

        customNavController.configureNavBar(
            title: "Day \(storage.dayCounter ?? 0)",
            leftButtonImage: UIImage(named: "leftButton"),
            rightButtonImage: UIImage(named: "rightButton"),
            leftAction: #selector(leftButtonTapped),
            rightAction: #selector(rightButtonTapped),
            target: self,
            hideBottomLine: true
        )
    }

    func initButtons() {
        // Настройка действий для кнопок
        customNavController.customNavBar.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        customNavController.customNavBar.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    func initHeader() {}

    @objc private func leftButtonTapped() {
        let settingsVC = StatsViewController()
        settingsVC.navigationItem.hidesBackButton = false
        let transition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(settingsVC, animated: false)
    }

    @objc private func rightButtonTapped() {
        
        let settingsVC = StatsViewController()
        settingsVC.navigationItem.hidesBackButton = false
        let transition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        let rightButton = ProfileViewController()
        rightButton.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(rightButton, animated: false)
        
// -----  Native animation when main screen slighly moving to the right
//        let rightButton = ProfileViewController()
//        rightButton.navigationItem.hidesBackButton = true
//        navigationController?.pushViewController(rightButton, animated: true)
    }
}


// MARK: - scrollViewDidEndDragging
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
