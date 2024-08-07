/*

Этот класс CreateNewStreakViewController:
1 - Управляет экраном для создания новой привычки, содержит представление CreateNewStreakView.
2 - Настраивает элементы интерфейса, включая навигационную панель с кнопками сохранения и отмены.
3 - Сохраняет новую привычку в базу данных и выводит все сохраненные привычки в консоль.

*/

import UIKit

class CreateNewStreakViewController: UIViewController, UINavigationControllerDelegate {
    let mainView = CreateNewStreakView()
    private let customNavController = CustomNavigationController()
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var panGesture: UIPanGestureRecognizer!
    var isInvertedSwipe: Bool = false
    var selectedColor: UIColor = .yellowRegular
    var selectedIcon: String = "plus_ic"
    
    var navBarHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
            return 72 + window.safeAreaInsets.top
        }
        return 72
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
        mainView.setNavBarHeight(navBarHeight)
        setupButtonActions()
        navigationController?.delegate = self
        isInvertedSwipe = true
        updateIconUI(with: selectedIcon)
        updateUI(with: selectedColor)
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    @objc private func dissmis() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveStreak() {
        guard let streakName = mainView.streakNameTextField.text, !streakName.isEmpty else {
            print("Streak name is empty.")
            return
        }

        // Create an instance of HabitsModel
        let newHabit = HabitsModel()
        newHabit.name = streakName
        newHabit.color = colorName(for: selectedColor) // Сохранить выбранный цвет
        newHabit.icon = selectedIcon // Сохранить выбранную иконку

        // Save the new habit to Realm using HabitsDataManager
        HabitsDataManager.shared.saveHabitsToRealm(habitsModel: newHabit)

        print("Saving streak with name: \(streakName), color: \(newHabit.color), and icon: \(selectedIcon)")

        // Optionally, pop or dismiss the view controller
        navigationController?.popViewController(animated: true)
        
        // Вывод всех сохранённых привычек
        let allSavedHabits = HabitsDataManager.shared.loadAllHabitsFromRealm()
        for habit in allSavedHabits {
            print("Saved Habit: \(habit.name), Color: \(habit.color), Icon: \(habit.icon)")
        }
    }
}


// MARK: - Navigation and Back Swiping
extension CreateNewStreakViewController {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = SwipeBackTransition()
        if operation == .pop {
            transition.isInverted = isInvertedSwipe
        } else {
            transition.isInverted = false
        }
        return transition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func initViewController() {
        setupCustomNavigationBar()
        initButtons()
        initHeader()
        setupPanGesture()
    }
    
    private func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func toggleSwipeDirection() {
        isInvertedSwipe = !isInvertedSwipe
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let progress = isInvertedSwipe ? translation.x / view.bounds.width : -translation.x / view.bounds.width
        
        switch gesture.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            interactionController?.completionSpeed = 0.99
            navigationController?.popViewController(animated: true)
        case .changed:
            interactionController?.update(min(max(progress, 0), 1))
        case .cancelled:
            interactionController?.cancel()
            interactionController = nil
        case .ended:
            if progress > 0.5 || gesture.velocity(in: view).x > 300 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            break
        }
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
        
        // Initial setup based on default selected color
        updateUI(with: selectedColor)
        
        navigationItem.hidesBackButton = true
    }
    
    private func colorName(for color: UIColor) -> String {
        switch color {
        case UIColor.redRegular:
            return "red"
        case UIColor.orangeRegular:
            return "orange"
        case UIColor.yellowRegular:
            return "yellow"
        case UIColor.blueRegular:
            return "blue"
        case UIColor.lilacRegular:
            return "lilac"
        case UIColor.greenRegular:
            return "green"
        case UIColor.purpleRegular:
            return "purple"
        case UIColor.pinkRegular:
            return "pink"
        case UIColor.violetRegular:
            return "violet"
        default:
            return "yellow" // Default case
        }
    }
    
    func initButtons() {
        // Настройка действий для кнопок
        customNavController.customNavBar.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        customNavController.customNavBar.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    func initHeader() {}
    
    @objc private func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightButtonTapped() {
        saveStreak()
    }
}

// MARK: - Icon and Color Selection
extension CreateNewStreakViewController {
    @objc private func openColorPopup() {
        let popupVC = PopupColorSetup()
        popupVC.selectedColor = selectedColor  // Установите выбранный цвет
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.onColorSelected = { [weak self] selectedColor in
            self?.updateUI(with: selectedColor)
            self?.selectedColor = selectedColor  // Обновите выбранный цвет
        }
        present(popupVC, animated: true, completion: nil)
    }
    
    private func updateIconUI(with iconName: String) {
        let whiteIconName = iconName.whiteIconName()
        if let iconImage = UIImage(named: whiteIconName) {
            if let innerIconView = mainView.iconImageView.subviews.first as? UIImageView {
                innerIconView.image = iconImage
            } else {
                let innerIconView = UIImageView(image: iconImage)
                innerIconView.contentMode = .scaleAspectFit
                innerIconView.layer.cornerRadius = 8
                innerIconView.layer.masksToBounds = true
                mainView.iconImageView.addSubview(innerIconView)
                innerIconView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.height.width.equalTo(40)
                }
            }
        } else {
            print("Failed to load image for icon named: \(whiteIconName)")
        }
    }
    
    @objc private func openIconPopup() {
        let popupVC = PopupIconSetup()
        popupVC.selectedIcon = selectedIcon // Set the currently selected icon
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.onIconSelected = { [weak self] selectedIcon in
            self?.updateIconUI(with: selectedIcon)
            self?.selectedIcon = selectedIcon // Update the selected icon
        }
        present(popupVC, animated: true, completion: nil)
    }
    
    private func setupButtonActions() {
            let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(openColorPopup))
            mainView.colorContainer.addGestureRecognizer(colorTapGesture)

            let iconTapGesture = UITapGestureRecognizer(target: self, action: #selector(openIconPopup))
            mainView.iconContainer.addGestureRecognizer(iconTapGesture)
        }
    
    func updateUI(with color: UIColor) {
        mainView.updateButtonColors(with: color)
        
        // Update navigation bar icons based on selected color
        let colorName = colorName(for: color)
        let leftIconName = "\(colorName)Back"
        let rightIconName = "\(colorName)Checkmark"
        
        customNavController.configureNavBar(
            title: "New",
            leftButtonImage: UIImage(named: leftIconName),
            rightButtonImage: UIImage(named: rightIconName),
            leftAction: #selector(leftButtonTapped),
            rightAction: #selector(rightButtonTapped),
            target: self,
            hideBottomLine: false
        )
    }

}

extension String {
    func whiteIconName() -> String {
        return self.replacingOccurrences(of: "_ic", with: "_white_ic")
    }
}

