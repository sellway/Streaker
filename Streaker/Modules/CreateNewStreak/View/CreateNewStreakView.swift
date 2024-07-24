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
    
    let iconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "yellowRegular")
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let iconLabel: UILabel = {
        let label = UILabel()
        label.text = "Icon"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let colorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let colorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "yellowRegular")
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Color"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
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
        setupIconAndColorContainers()
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
            make.height.equalTo(50)
        }
    }
}

// MARK: - Icon and Color Setup
extension CreateNewStreakView {
    private func setupIconAndColorContainers() {
        addSubview(iconContainer)
        addSubview(colorContainer)
        
        iconContainer.addSubview(iconImageView)
        iconContainer.addSubview(iconLabel)
        
        colorContainer.addSubview(colorImageView)
        colorContainer.addSubview(colorLabel)
        
        iconContainer.snp.remakeConstraints { make in
            make.top.equalTo(streakNameTextField.snp.bottom).offset(16)
            make.leading.equalTo(streakNameTextField)
            make.height.equalTo(64)
            make.width.equalTo(streakNameTextField).multipliedBy(0.5)
        }
        
        colorContainer.snp.remakeConstraints { make in
            make.top.equalTo(streakNameTextField.snp.bottom).offset(16)
            make.trailing.equalTo(streakNameTextField)
            make.leading.equalTo(iconContainer.snp.trailing).offset(8)
            make.height.equalTo(64)
            make.width.equalTo(streakNameTextField).multipliedBy(0.5).offset(-4)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.width.equalTo(64) // Оставляем размер фона 64x64
        }

        // Добавляем UIImageView для иконки внутри iconImageView
        let innerIconView = UIImageView()
        innerIconView.contentMode = .scaleAspectFit
        innerIconView.layer.cornerRadius = 8
        innerIconView.layer.masksToBounds = true
        iconImageView.addSubview(innerIconView)
        innerIconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(40)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        colorImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        // Добавляем белый круг по умолчанию
        let circleView = UIView()
        circleView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        circleView.layer.cornerRadius = 16
        circleView.layer.masksToBounds = true
        colorImageView.addSubview(circleView)

        // Устанавливаем констрейнты для круга
        circleView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.center.equalToSuperview()
        }
    }



    
    func updateButtonColors(with color: UIColor) {
        iconImageView.backgroundColor = color
        colorImageView.backgroundColor = color

        // Удаляем старый круг, если он существует
        colorImageView.subviews.forEach { $0.removeFromSuperview() }

        // Добавляем белый круг
        let circleView = UIView()
        circleView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        circleView.layer.cornerRadius = 16
        circleView.layer.masksToBounds = true
        colorImageView.addSubview(circleView)

        // Устанавливаем констрейнты для круга
        circleView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.center.equalToSuperview()
        }
    }
    
}
