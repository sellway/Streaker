/*

Этот класс StatsViewController:
1 - Использует StatsView для отображения статистики и элементов управления.

*/

import UIKit

class StatsViewController: UIViewController {
    
    let mainView = StatsView()
    private let customNavController = CustomNavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initHeader()
        initViewController()
        
//        mainView.closeButton.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
    }
    
//    private func initHeader() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.closeButton)
//        
//        navigationItem.titleView = mainView.headerTitleLabel
//    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
}

// MARK: - Init View Controller
extension StatsViewController {
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    
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
            title: "Stats",
            leftButtonImage: nil,
            rightButtonImage:  UIImage(named: "rightButton"),
            leftAction: nil,
            rightAction: #selector(rightButtonTapped),
            target: self
        )
        navigationItem.hidesBackButton = true
    }

    func initButtons() {
        // Настройка действий для кнопок
        customNavController.customNavBar.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    func initHeader() {}

    @objc private func rightButtonTapped() {
        let transition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .reveal
        transition.subtype = .fromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }
}
