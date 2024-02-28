import UIKit
import SnapKit

class ButtonLabel: UILabel {
    
    // В Swift, когда вы создаете подкласс UIView (или любого класса, который является частью UIKit), вам нужно реализовать два инициализатора.
    // Initializes the label with default settings.
    init() {
        super.init(frame: .zero)
        setupLabel()
    }
    
    // Required initializer for decoding from nib or storyboard.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    // Sets up the label with default styling.
    private func setupLabel() {
        textColor = .white
        font = UIFont.systemFont(ofSize: 10, weight: .medium)
        updateText(with: "Text", isOn: false)
    }
    
    // Updates the label's position to be below a specified button using SnapKit.
    func updatePosition(below button: UIButton) {
        
        // Функция добавляет метку в ту же "родительскую" вью, что и у кнопки.
        guard let superview = button.superview else { return }
        superview.addSubview(self)
        
        self.snp.makeConstraints { make in
            make.centerX.equalTo(button)
            make.top.equalTo(button.snp.bottom)
            make.width.equalTo(84)
            make.height.equalTo(16)
        }
    }
    
    // Updates the label's text and alpha (transparency).
    func updateText(with text: String, isOn: Bool) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.6
            paragraphStyle.alignment = .center

            UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
                if isOn {
                    // Если кнопка включена, показываем "DONE!"
                    self.attributedText = NSMutableAttributedString(string: "DONE!", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                } else {
                    // Если выключена, показываем переданный текст
                    self.attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                }
                self.alpha = isOn ? 1.0 : 0.8
            }, completion: nil)
        }
}
