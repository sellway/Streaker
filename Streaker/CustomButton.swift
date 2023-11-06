import UIKit
import SnapKit
import Lottie

class CustomButton: UIButton {
    
    // Добавляем замыкание, которое будет вызываться при нажатии на кнопку
    var onButtonTapped: (() -> Void)?
    // Добавьте это свойство для хранения размера кнопки
    var buttonSize: CGSize = .zero
    
    var isOn: Bool = false {
        didSet {
            print("Button state changed: \(isOn)")
            toggleButton()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    private let overlayView = UIView()
    private let iconView = UIImageView()
    private let labelBelowButton = ButtonLabel() // Using the ButtonLabel class
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
                make.height.equalTo(16)
            }
        }
    }
    
    private func setupButton() {
        setupGradientLayer()
        setupOverlayView()
        setupIconView()
        setupButtonProperties()
        setupConfettiAnimation()
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor(red: 0.051, green: 0.78, blue: 0.345, alpha: 1).cgColor,
            UIColor(red: 0.051, green: 0.692, blue: 0.309, alpha: 1).cgColor
        ]
        gradientLayer.cornerRadius = 18
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupOverlayView() {
        overlayView.backgroundColor = .white.withAlphaComponent(0.08)
        overlayView.layer.cornerRadius = 18
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
            make.width.height.equalTo(32) // Default size, will be scaled later
        }
    }
    
    private func setupButtonProperties() {
        layer.cornerRadius = 18
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        scaleButtonElements(forScreenWidth: UIScreen.main.bounds.width)
    }

    @objc private func buttonTapped() {
        print("Button tapped")
         isOn.toggle()
         if isOn {
             superview?.bringSubviewToFront(self)
             playConfettiAnimation()
         }
        // Вызываем замыкание после изменения состояния кнопки
        onButtonTapped?()
    }
    
    func setPositionAtBottomCenter(in view: UIView, index: Int, totalButtons: Int) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false

        let baseScreenWidth: CGFloat = 375 // Width of iPhone SE screen
        let scaleFactor = view.bounds.width / baseScreenWidth

        let buttonWidth: CGFloat = 74 * scaleFactor
        let buttonSpacing: CGFloat = 16 * scaleFactor
        let totalWidth = CGFloat(totalButtons) * buttonWidth + CGFloat(totalButtons - 1) * buttonSpacing
        let xOffset = (view.bounds.width - totalWidth) / 2 + CGFloat(index) * (buttonWidth + buttonSpacing)

        self.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.leading).offset(xOffset + buttonWidth / 2)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-28)
            make.width.height.equalTo(buttonWidth)
        }
        
        // Сохраните размер кнопки здесь
        self.buttonSize = CGSize(width: buttonWidth, height: buttonWidth)
        
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
            gradientLayer.colors = [
                UIColor(red: 0.29, green: 0.79, blue: 0.49, alpha: 1).cgColor,
                UIColor(red: 0.29, green: 0.79, blue: 0.49, alpha: 1).cgColor
            ]
            gradientLayer.cornerRadius = 16
            
            overlayView.layer.cornerRadius = 15
            overlayView.layer.borderWidth = 1
            overlayView.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
            overlayView.backgroundColor = .clear
            
            iconView.image = UIImage(named: "meditation_done")
        } else {
            gradientLayer.colors = [
                UIColor(red: 0.051, green: 0.78, blue: 0.345, alpha: 1).cgColor,
                UIColor(red: 0.051, green: 0.692, blue: 0.309, alpha: 1).cgColor
            ]
            gradientLayer.cornerRadius = 16

            overlayView.layer.cornerRadius = 15
            overlayView.layer.borderWidth = 0
            overlayView.layer.borderColor = UIColor.clear.cgColor
            overlayView.backgroundColor = .white.withAlphaComponent(0.08)
            
            iconView.image = UIImage(named: "meditation")
        }
        labelBelowButton.updateText(isOn: isOn)
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

    
    private func playConfettiAnimation() {
            print("Playing confetti animation") // Для отладки
            guard let superview = self.superview else {
                print("Superview is nil")
                return
            }
            confettiAnimationView!.isHidden = false
            superview.bringSubviewToFront(confettiAnimationView!)
            confettiAnimationView!.play { [weak self] finished in
                if finished {
                    self?.confettiAnimationView!.isHidden = true
                }
            }
        }
}
