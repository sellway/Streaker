/*

Этот класс NewStreakViewController:
1 - Управляет представлением для создания новых привычек, включая таблицу с выбором типов привычек.
2 - Инициализирует и настраивает компоненты пользовательского интерфейса, такие как кнопки и заголовки.
3 - Обрабатывает пользовательские взаимодействия, включая переходы на другие контроллеры и закрытие текущего представления.

*/

import UIKit

class NewStreakViewController: UIViewController, UINavigationControllerDelegate {
    let mainView = NewStreakView()
    var streakModel = NewStreakModel.allCases
    private let customNavController = CustomNavigationController()
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var panGesture: UIPanGestureRecognizer!
    var isInvertedSwipe: Bool = false
    
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
        mainView.listsTableView.delegate = self
        mainView.listsTableView.dataSource = self
        mainView.listsTableView.registerReusableCell(NewStreakCell.self)
        // Go to createStreakVC when click on create your own streak button
        mainView.onCreateStreakButtonTapped = { [weak self] in
            let createStreakVC = CreateNewStreakViewController()
            self?.navigationController?.pushViewController(createStreakVC, animated: true)
        }
        navigationController?.delegate = self
        isInvertedSwipe = true
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    @objc private func dissmis() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView

extension NewStreakViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        streakModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewStreakCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = streakModel[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.sizeH
        
    }
}


// MARK: - Navigation and Back Swiping
extension NewStreakViewController {
    
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
        
        customNavController.configureNavBar(
            title: "New Streak",
            leftButtonImage: UIImage(named: "yellowBack"),
            rightButtonImage: nil,
            leftAction: #selector(rightButtonTapped),
            rightAction: nil,
            target: self,
            hideBottomLine: false
        )
        navigationItem.hidesBackButton = true
    }
    
    func initButtons() {
        // Настройка действий для кнопок
        customNavController.customNavBar.leftButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    func initHeader() {}
    
    @objc private func rightButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

