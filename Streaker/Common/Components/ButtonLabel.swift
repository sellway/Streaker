/*
Этот класс `ButtonLabel`:

1 - Создает кастомный UILabel для кнопок с настройками по умолчанию, включая цвет текста и шрифт.
2 - Обновляет положение метки, размещая ее под заданной кнопкой через SnapKit.
3 - Использует метод `updateText` для переключения текста между "DONE!" и именем привычки в зависимости от состояния кнопки, с плавной анимацией прозрачности.
4 - Предоставляет метод `resetToDefault`, который возвращает текст к исходному значению.
*/


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
    }
    
    // Updates the label's text and alpha (transparency).
    func updateText(with text: String, isOn: Bool) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.6
        paragraphStyle.alignment = .center

        UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.attributedText = NSMutableAttributedString(string: isOn ? "DONE!" : text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
            self.alpha = 1.0
        }, completion: { _ in
            if isOn {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
                        self.attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                        self.alpha = 0.8
                    }, completion: nil)
                }
            }
        })
    }
    
    // Resets the label to its default state.
        func resetToDefault() {
            updateText(with: "Default", isOn: false)
        }
    
}
