/*

Этот класс NewStreakViewController:
1 - Управляет представлением для создания новых привычек, включая таблицу с выбором типов привычек.
2 - Инициализирует и настраивает компоненты пользовательского интерфейса, такие как кнопки и заголовки.
3 - Обрабатывает пользовательские взаимодействия, включая переходы на другие контроллеры и закрытие текущего представления.

*/

import UIKit

class NewStreakViewController: UIViewController {
    let mainView = NewStreakView()
    var streakModel = NewStreakModel.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.listsTableView.delegate = self
        mainView.listsTableView.dataSource = self
        mainView.listsTableView.registerReusableCell(NewStreakCell.self)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.cancelButton)
        navigationItem.titleView = mainView.headerTitleLabel
        mainView.cancelButton.addTarget(self, action: #selector(dissmis), for: .touchUpInside)
        // Go to createStreakVC when click on create your own streak button
        mainView.onCreateStreakButtonTapped = { [weak self] in
            let createStreakVC = CreateNewStreakViewController()
            self?.navigationController?.pushViewController(createStreakVC, animated: true)
        }
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    @objc private func dissmis() {
        navigationController?.popViewController(animated: true)
    }
}

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
