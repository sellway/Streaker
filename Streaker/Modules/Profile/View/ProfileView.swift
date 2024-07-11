/*
 
 Этот класс `ProfileView`:
 1 - Создаёт таблицу для отображения элементов профиля и предоставляет кнопку для выхода.
 2 - Настраивает внешний вид таблицы и кнопки, применяя стили и размещая их с помощью SnapKit.
 3 - Устанавливает необходимые ограничения для правильного размещения элементов на экране.
 
 */

import UIKit
import SnapKit

class ProfileView: UIView {
    
    private var navBarHeight: CGFloat = 0
    
    let listsTableView: UITableView = {
        let obj = UITableView()
        obj.showsVerticalScrollIndicator = false
        obj.showsHorizontalScrollIndicator = false
        obj.backgroundColor = .theme(.backgroundMain)
        return obj
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - List Setup
extension ProfileView {
    
    func setNavBarHeight(_ height: CGFloat) {
        self.navBarHeight = height
        setNeedsLayout()
    }
    
    private func setup() {
        addSubview(listsTableView)
        self.backgroundColor = .theme(.streakerGrey)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topInset = navBarHeight
        listsTableView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(topInset)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

