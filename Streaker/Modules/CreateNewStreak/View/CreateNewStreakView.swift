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
    
    private func makeConstraints() {
        streakNameTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
}
