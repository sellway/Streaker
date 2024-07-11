/*

Этот класс NewStreakView:
1 - Создает пользовательский интерфейс для создания или выбора новой привычки.
2 - Содержит кнопки для создания собственной привычки и таблицу для выбора из предложенных тем.
3 - Устанавливает ограничения для элементов с использованием SnapKit и настраивает их внешний вид.

*/

import UIKit
import SnapKit

class NewStreakView: UIView {
    
    var onCreateStreakButtonTapped: (() -> Void)?
    private var navBarHeight: CGFloat = 0
    
    let topButton: UIView = {
       let obj = UIView()
        obj.backgroundColor = .theme(.lineGrey)
        obj.layer.cornerRadius = 26
        obj.clipsToBounds = true
        return obj
    }()
    
    let clearButton: UIButton = {
       let obj = UIButton()
        obj.backgroundColor = .clear
        return obj
    }()
    
    let btnIcon: UIImageView = {
       let obj = UIImageView()
        obj.image = .theme(.plus)
        return obj
    }()
    
    let titleLabel: UILabel = {
       let obj = UILabel()
        
        obj.text = "Create your own streak"
        obj.textColor = .white
        obj.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return obj
    }()
    
    let listsTableView: UITableView = {
        let obj = UITableView()
        obj.showsVerticalScrollIndicator = false
        obj.showsHorizontalScrollIndicator = false
        obj.backgroundColor = .theme(.lineGrey)
        obj.layer.cornerRadius = 26
        return obj
    }()
    
    let selectTitle: UILabel = {
        let obj = UILabel()
        
        obj.text = "Or select from these topics"
        obj.textColor = .white
        obj.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return obj
    }()
    
    @objc private func topButtonTapped() {
        onCreateStreakButtonTapped?()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - List Setup
extension NewStreakView {
    
    func setNavBarHeight(_ height: CGFloat) {
        self.navBarHeight = height
        setNeedsLayout()
    }
    
    private func setup() {
            addSubview(listsTableView)
            addSubview(topButton)
            addSubview(selectTitle)
            topButton.addSubview(clearButton)
            clearButton.addSubview(btnIcon)
            clearButton.addSubview(titleLabel)
        self.backgroundColor = .theme(.backgroundMain)
            // Do add custom streak button on top clickable
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topButtonTapped))
            clearButton.addGestureRecognizer(tapGesture)
            clearButton.isUserInteractionEnabled = true
            makeConstraints()
        }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            makeConstraints()
        }
    
    private func makeConstraints() {
        
        let topInset = navBarHeight
        
        topButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(topInset + 16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64.sizeH)
        }
        
        selectTitle.snp.makeConstraints { make in
            make.top.equalTo(topButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        listsTableView.snp.makeConstraints { make in
            make.top.equalTo(selectTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        btnIcon.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(21)
            make.width.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(btnIcon.snp.trailing).offset(12)
        }
    }
}
