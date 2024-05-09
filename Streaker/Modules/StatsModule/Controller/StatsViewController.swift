/*

Этот класс StatsViewController:
1 - Использует StatsView для отображения статистики и элементов управления.

*/

import UIKit

class StatsViewController: UIViewController {
    
    let mainView = StatsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initHeader()
        
        mainView.closeButton.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
    }
    
    private func initHeader() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.closeButton)
        
        navigationItem.titleView = mainView.headerTitleLabel
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    @objc
    private func closeTap() {
        navigationController?.popViewController(animated: true)
    }
}
