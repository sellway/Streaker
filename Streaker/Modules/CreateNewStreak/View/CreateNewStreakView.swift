import UIKit
import SnapKit

class CreateNewStreakView: UIView {
    
    let streakNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name of the streak in 1-2 words"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = .none
        textField.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 46/255, alpha: 1)
        textField.textColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        return textField
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(streakNameTextField)
        makeConstraints()
    }
    
    let cancelButton: UIButton = {
        let obj = UIButton()
        obj.setImage(UIImage(named: "leftArrow"), for: .normal)
        obj.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 46/255, alpha: 1)
        obj.tintColor = .theme(.streakerGrey)
        obj.layer.cornerRadius = 12
        obj.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
        obj.layer.borderWidth = 0.2
        return obj
    }()
    
    private func makeConstraints() {
        
        cancelButton.snp.makeConstraints { make in
            make.size.width.equalTo(74.sizeW)
            make.size.height.equalTo(54.sizeH)
        }
        
        streakNameTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
}
