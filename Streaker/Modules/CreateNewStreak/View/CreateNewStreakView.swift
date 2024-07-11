/*
 
 Этот класс CreateNewStreakView:
 1 - Содержит текстовое поле для ввода названия новой привычки и кнопку отмены для возврата назад.
 2 - Добавляет элементы на родительский UIView и устанавливает для них ограничения с помощью SnapKit.
 3 - Настраивает внешний вид текстового поля и кнопки отмены.
 
 */


import UIKit
import SnapKit

class CreateNewStreakView: UIView {
    
    private var navBarHeight: CGFloat = 0
    
    let streakNameTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = "Name of the streak in 1-2 words"
        let placeholderColor = UIColor.white.withAlphaComponent(0.5)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = .none
        textField.backgroundColor = .theme(.lineGrey)
        textField.textColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.textAlignment = .left
        return textField
    }()
    
    init() {
        super.init(frame: .zero)
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
        addSubview(streakNameTextField)
        self.backgroundColor = .theme(.backgroundMain)
        makeConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        let topInset = navBarHeight
        streakNameTextField.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(topInset + 16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50.sizeH)
        }
    }
}
