/*

Этот класс MyStreaksView:
1 - Создает таблицу (UITableView) для отображения списка привычек.
2 - Регистрирует базовый тип ячейки для использования в таблице.
3 - Устанавливает констрейнты для таблицы, обеспечивая ее растяжение на весь доступный простор родительского представления.

*/

import UIKit
import SnapKit

class MyStreaksView: UIView {
    
    private var navBarHeight: CGFloat = 0
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNavBarHeight(_ height: CGFloat) {
        self.navBarHeight = height
        setNeedsLayout()
    }

    private func setup() {
        addSubview(tableView)
        self.backgroundColor = .theme(.streakerGrey)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topInset = navBarHeight
        tableView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(topInset)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
