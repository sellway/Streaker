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
        imageView.backgroundColor = .yellow
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
        imageView.backgroundColor = .yellow
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
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(colorContainer.snp.leading).offset(-8)
            make.height.equalTo(64)
            make.width.equalTo(colorContainer)
        }
        
        colorContainer.snp.remakeConstraints { make in
            make.top.equalTo(streakNameTextField.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
            make.width.equalTo(iconContainer)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        colorImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
}
