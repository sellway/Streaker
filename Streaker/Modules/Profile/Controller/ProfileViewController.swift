/*
 
 Этот класс `ProfileViewController`:
 1 - Управляет экраном профиля, инициализирует и настраивает элементы через метод `initViewController`.
 2 - Настраивает таблицу для отображения элементов профиля с использованием модели `ProfileModel`.
 3 - Обрабатывает выбор элементов таблицы, выполняя соответствующие действия, такие как переход на другой экран или показ алерта.
 
 */

import UIKit
import MessageUI


class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    let mainView = ProfileView()
    var profileModel = ProfileModel.allCases
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
        mainView.listsTableView.registerReusableCell(ProfileButtonCell.self)
        navigationController?.delegate = self
        isInvertedSwipe = true
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
        
    }
    
    func showPauseAlert() {
        let alertController = UIAlertController(
            title: nil,
            message: "Are you sure you want to pause everything?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(
            title: "Yes",
            style: .default,
            handler: { _ in
                
            }
        )
        
        let noAction = UIAlertAction(
            title: "No",
            style: .destructive,
            handler: { _ in
                
            }
        )
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func openMessageWindow() {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail Service is NOT available")
            
            let errorController = UIAlertController(title: "Dear User", message: "Sorry, but Write To Us Service is temporarily unavailable. Please try again later.", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            errorController.addAction(okAction)
            present(errorController, animated: true)
            
            return
        } else {
            
            print("Mail Service IS working")
            
            let composeController = MFMailComposeViewController()
            composeController.mailComposeDelegate = self
            
            composeController.setToRecipients(["stakeYourSkillsFeedback@gmail.com"])
            composeController.setSubject("Message Subject")
            composeController.setMessageBody("Message content", isHTML: false)
            
            self.present(composeController, animated: true, completion: nil)
        }
    }
    
    
}

// MARK: - TableView

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProfileButtonCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = profileModel[indexPath.row]
        cell.backgroundColor = .theme(.backgroundMain)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.sizeH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        switch row {
        case 0:
            print("addNewStreak")
            let vc = NewStreakViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            print("myStreaks")
            let myStreaksVC = MyStreaksViewController()
            navigationController?.pushViewController(myStreaksVC, animated: true)
        case 2:
            print("howItWorks")
        case 3:
            print(3)
            showPauseAlert()
        case 4:
            print(4)
            openMessageWindow()
        case 5:
            print(5)
            let vc = SettingsViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("")
        }
    }
}


// MARK: - Navigation and Back Swiping
extension ProfileViewController {
    
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
            title: "Stats",
            leftButtonImage: nil,
            rightButtonImage: UIImage(named: "greenCloseButton"),
            leftAction: nil,
            rightAction: #selector(rightButtonTapped),
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
