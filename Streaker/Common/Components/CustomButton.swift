/*
 Этот код:
 1 - Создает кастомную кнопку `CustomButton` с функциями изменения цвета, состояния и лейблом под кнопкой.
 2 - Управляет состоянием кнопки через замыкание `onButtonTapped` и изменяет визуальное оформление при переключении состояния `isOn`.
 3 - Использует словарь `colorThemes` для разных цветовых тем кнопок и настраивает градиенты или однотонные цвета.
 4 - Включает поддержку иконки и лейбла, а также масштабирует элементы кнопки в зависимости от ширины экрана.
 5 - Поддерживает анимацию конфетти через библиотеку Lottie (временно отключена), и изменяет дизайн на основе состояния.
 6 - Применяет SnapKit для упрощенного размещения элементов.
 */


import UIKit
import SnapKit
import Lottie

class CustomButton: UIButton {
    
    var habitName: String = ""
    
    struct ButtonColors {
        let buttonDefault: (gradientStart: UIColor, gradientEnd: UIColor)
        let buttonDone: UIColor
    }
    
    // Добавляем замыкание, которое будет вызываться при нажатии на кнопку
    var onButtonTapped: (() -> Void)?
    // Добавьте это свойство для хранения размера кнопки
    static var buttonSize: CGSize = .zero
    
    var isOn: Bool = false {
        didSet {
            print("Button state changed: \(isOn)")
            toggleButton()
        }
    }
    
    private let buttonLayer = CAGradientLayer()
    private let overlayView = UIView()
    private let iconView = UIImageView()
    let labelBelowButton = ButtonLabel() // Using the ButtonLabel class
    private var confettiAnimationView: LottieAnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            superview.addSubview(labelBelowButton)
            labelBelowButton.snp.makeConstraints { make in
                make.centerX.equalTo(self)
                make.top.equalTo(self.snp.bottom)
                make.width.equalTo(84)
                make.height.equalTo(20)
            }
        }
    }
    
    private func setupButton() {
        // Задаем цвет кнопки по умолчанию
        if let theme = CustomButton.colorThemes["green"] {
            setupButtonLayer(theme: theme)
        }
        setupOverlayView()
        setupIconView()
        setupButtonProperties()
        //setupConfettiAnimation()
    }
    
    private func setupButtonLayer(theme: ButtonColors) {
        buttonLayer.colors = [
            theme.buttonDefault.gradientStart.cgColor,
            theme.buttonDefault.gradientEnd.cgColor
        ]
        buttonLayer.cornerRadius = 18
        layer.insertSublayer(buttonLayer, at: 0)
    }
    
    private func setupOverlayView() {
        overlayView.backgroundColor = .white.withAlphaComponent(0.08)
        overlayView.layer.cornerRadius = 15
        overlayView.isUserInteractionEnabled = false
        addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        }
    }
    
    private func setupIconView() {
        iconView.image = UIImage(named: "meditation")
        iconView.isUserInteractionEnabled = false
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(74) // Default size, will be scaled later
        }
    }
    
    private func setupButtonProperties() {
        layer.cornerRadius = 16
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonLayer.frame = bounds
        scaleButtonElements(forScreenWidth: UIScreen.main.bounds.width)
    }
    
    @objc private func buttonTapped() {
        print("Button tapped")
        isOn.toggle()
        superview?.bringSubviewToFront(self)
        if isOn {
            superview?.bringSubviewToFront(self)
            //playConfettiAnimation()
        }
        // Вызываем замыкание после изменения состояния кнопки
        onButtonTapped?()
    }
    
    func setPosition(in view: UIView, index: Int, totalButtons: Int) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let baseScreenWidth: CGFloat = 375 // Width of iPhone SE screen
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = screenWidth / baseScreenWidth
        let buttonWidth: CGFloat = 74 * scaleFactor
        let buttonSpacing: CGFloat = 16 * scaleFactor
        let totalWidth = CGFloat(totalButtons) * buttonWidth + CGFloat(totalButtons - 1) * buttonSpacing
        let xOffset = (UIScreen.main.bounds.width - totalWidth) / 2 + CGFloat(index) * (buttonWidth + buttonSpacing)
        
        if totalButtons <= 4 {
            self.snp.makeConstraints { make in
                make.centerX.equalTo(view.snp.leading).offset(xOffset + buttonWidth / 2)
                            make.bottom.equalToSuperview().offset(-48)
                            make.width.height.equalTo(buttonWidth)
            }
        } else {
            self.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(buttonSpacing + CGFloat(index) * (buttonWidth + buttonSpacing))
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-28)
                make.width.height.equalTo(buttonWidth)
            }
        }
        CustomButton.buttonSize = CGSize(width: buttonWidth, height: buttonWidth)
        view.bringSubviewToFront(self)
    }
    
    
    func scaleButtonElements(forScreenWidth screenWidth: CGFloat) {
        let baseScreenWidth: CGFloat = 375 // Base screen width, e.g., iPhone SE
        let scaleFactor = screenWidth / baseScreenWidth
        
        let iconSize: CGFloat = 32 * scaleFactor // Scaled icon size
        let fontSize: CGFloat = 10 * scaleFactor // Scaled font size
        
        iconView.snp.updateConstraints { make in
            make.width.height.equalTo(iconSize)
        }
        
        labelBelowButton.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func toggleButton() {
        UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.updateButtonAppearance()
        }, completion: { _ in
            if self.isOn {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.labelBelowButton.resetToDefault()
                }
            }
        })
    }
    
    
    private func updateButtonAppearance() {
        if isOn {
            // If you want a solid color appearance, use the same color for both gradient start and end.
            let solidColor = CustomButton.colorThemes["green"]!.buttonDone.cgColor
            buttonLayer.colors = [solidColor, solidColor]
            buttonLayer.cornerRadius = 16
            
            overlayView.layer.cornerRadius = 15
            overlayView.layer.borderWidth = 1
            overlayView.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
            overlayView.backgroundColor = .clear
            
            iconView.image = UIImage(named: "meditation_done")
        } else {
            let defaultColors = CustomButton.colorThemes["green"]!.buttonDefault
            buttonLayer.colors = [defaultColors.gradientStart.cgColor, defaultColors.gradientEnd.cgColor]
            buttonLayer.cornerRadius = 16
            
            overlayView.layer.cornerRadius = 15
            overlayView.layer.borderWidth = 0
            overlayView.layer.borderColor = UIColor.clear.cgColor
            overlayView.backgroundColor = .white.withAlphaComponent(0.08)
            
            iconView.image = UIImage(named: "meditation")
        }
        labelBelowButton.updateText(with: habitName, isOn: isOn)
    }
    
    private func setupConfettiAnimation() {
        confettiAnimationView = .init(name: "confetti")
        confettiAnimationView!.isHidden = true // Анимация изначально скрыта
        confettiAnimationView!.contentMode = .scaleAspectFit
        confettiAnimationView!.loopMode = .playOnce
        addSubview(confettiAnimationView!)
        confettiAnimationView!.translatesAutoresizingMaskIntoConstraints = false
        
        // Расположение анимации так, чтобы она казалась вылетающей из-под кнопки
        NSLayoutConstraint.activate([
            confettiAnimationView!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            confettiAnimationView!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            confettiAnimationView!.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 4), // Ширина в 4 раза больше кнопки
            confettiAnimationView!.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 4) // Высота в 8 раза больше кнопки
        ])
    }
    
    
    //    private func playConfettiAnimation() {
    //        print("Playing confetti animation") // Для отладки
    //        guard let superview = self.superview else {
    //            print("Superview is nil")
    //            return
    //        }
    //        confettiAnimationView!.isHidden = false
    //        superview.bringSubviewToFront(confettiAnimationView!)
    //        // Здесь вы устанавливаете начальный и конечный кадры анимации
    //        confettiAnimationView!.play(fromFrame: 0, toFrame: 55, loopMode: .playOnce) { [weak self] finished in
    //            if finished {
    //                self?.confettiAnimationView!.isHidden = true
    //            }
    //        }
    //    }
    
    // Словарь с темами цветов для разных типов кнопок
    static var colorThemes: [String: ButtonColors] = [
        "red": ButtonColors(
            buttonDefault: (
                gradientStart: UIColor(red: 255/255, green: 98/255, blue: 153/255, alpha: 1),
                gradientEnd: UIColor(red: 240/255, green: 54/255, blue: 99/255, alpha: 1)
            ),
            buttonDone: UIColor(named: "redDone")!
        ),
        "orange": ButtonColors(
            buttonDefault: (
                gradientStart: UIColor(red: 255/255, green: 185/255, blue: 87/255, alpha: 1),
                gradientEnd: UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
            ),
            buttonDone: UIColor(named: "orangeDone")!
        ),
        "yellow": ButtonColors(
            buttonDefault: (
                gradientStart: UIColor(red: 255/255, green: 221/255, blue: 84/255, alpha: 1),
                gradientEnd: UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
            ),
            buttonDone: UIColor(named: "yellowDone")!
        ),
        "purple": ButtonColors(
            buttonDefault: (
                gradientStart: UIColor(red: 138/255, green: 139/255, blue: 240/255, alpha: 1),
                gradientEnd: UIColor(red: 93/255, green: 95/255, blue: 238/255, alpha: 1)
            ),
            buttonDone: UIColor(named: "purpleDone")!
        ),
        "blue": ButtonColors(
            buttonDefault: (
                gradientStart: UIColor(red: 12/255, green: 181/255, blue: 255/255, alpha: 1),
                gradientEnd: UIColor(red: 22/255, green: 133/255, blue: 255/255, alpha: 1)
            ),
            buttonDone: UIColor(named: "blueDone")!
        ),
        "green": ButtonColors(
            buttonDefault: (
                gradientStart: UIColor(red: 31/255, green: 195/255, blue: 97/255, alpha: 1),
                gradientEnd: UIColor(red: 13/255, green: 177/255, blue: 79/255, alpha: 1)
            ),
            buttonDone: UIColor(named: "greenDone")!
        ),
        "violet": ButtonColors(
            buttonDefault: (
                gradientStart: UIColor(red: 162/255, green: 111/255, blue: 211/255, alpha: 1),
                gradientEnd: UIColor(red: 138/255, green: 87/255, blue: 186/255, alpha: 1)
            ),
            buttonDone: UIColor(named: "violetDone")!
        ),
        "lilac": ButtonColors(
            buttonDefault: (
                gradientStart: UIColor(red: 205/255, green: 131/255, blue: 237/255, alpha: 1),
                gradientEnd: UIColor(red: 189/255, green: 119/255, blue: 219/255, alpha: 1)
            ),
            buttonDone: UIColor(named: "lilacRegular")!
        ),
        "pink": ButtonColors(
            buttonDefault: (
                gradientStart: UIColor(red: 255/255, green: 152/255, blue: 234/255, alpha: 1),
                gradientEnd: UIColor(red: 241/255, green: 102/255, blue: 213/255, alpha: 1)
            ),
            buttonDone: UIColor(named: "pinkDone")!
        ),
    ]
}
