import UIKit
import SnapKit

class ButtonLabel: UILabel {
    
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
        updateText(isOn: false)
    }
    
    // Updates the label's position to be below a specified button using SnapKit.
    func updatePosition(below button: UIButton) {
        guard let superview = button.superview else { return }
        
        superview.addSubview(self)
        self.snp.makeConstraints { make in
            make.centerX.equalTo(button)
            make.top.equalTo(button.snp.bottom)
            make.width.equalTo(84)
            make.height.equalTo(16)
        }
    }
    
    // Resets the label to its default state.
    func resetToDefault() {
        updateText(isOn: false)
    }
    
    // Updates the label's text and alpha (transparency).
    func updateText(isOn: Bool) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 16 / 10
        paragraphStyle.alignment = .center

        UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
            if isOn {
                // Text and style for "ON" state
                self.attributedText = NSMutableAttributedString(string: "DONE!", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                self.alpha = 1.0
            } else {
                // Text and style for "OFF" state
                self.attributedText = NSMutableAttributedString(string: "Meditation", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                self.alpha = 1.0
            }
        }, completion: { _ in
            if isOn {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
                        self.attributedText = NSMutableAttributedString(string: "Meditation", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                        self.alpha = 0.8
                    }, completion: nil)
                }
            }
        })
    }
}
