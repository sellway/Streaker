/*

Этот класс MyStreaksView:
1 - Создает таблицу (UITableView) для отображения списка привычек.
2 - Регистрирует базовый тип ячейки для использования в таблице.
3 - Устанавливает констрейнты для таблицы, обеспечивая ее растяжение на весь доступный простор родительского представления.

*/

import UIKit

class MyStreaksView: UIView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}

