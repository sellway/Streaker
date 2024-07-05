import UIKit
import SnapKit

class CustomNavigationBar: UIView {
    let leftButton = UIButton()
    let rightButton = UIButton()
    private let titleLabel = UILabel()
    private var topBlurEffectView: UIVisualEffectView?
    let bottomLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNavigationBarHeight() -> CGFloat {
            return self.frame.height
        }

    private func setupView() {
        let blurEffect = UIBlurEffect(style: .dark)
        topBlurEffectView = UIVisualEffectView(effect: blurEffect)
        guard let topBlurEffectView = topBlurEffectView else { return }

        addSubview(topBlurEffectView)
        addSubview(leftButton)
        addSubview(rightButton)

        // Добавление контейнера для titleLabel
        let titleContainer = UIView()
        addSubview(titleContainer)
        titleContainer.addSubview(titleLabel)

        topBlurEffectView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }

        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
                make.top.equalToSuperview().offset(window.safeAreaInsets.top)
            }
        }

        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
                make.top.equalToSuperview().offset(window.safeAreaInsets.top)
            }
        }

        // Настройка ограничений для titleContainer
        titleContainer.snp.makeConstraints { make in
            make.left.equalTo(leftButton.snp.right).offset(8)
            make.right.equalTo(rightButton.snp.left).offset(-8)
            make.centerX.equalToSuperview()
            if leftButton.isHidden {
                    make.centerY.equalTo(rightButton.snp.centerY)
                } else {
                    make.centerY.equalTo(leftButton.snp.centerY)
                }
        }

        // Настройка ограничений для titleLabel внутри контейнера
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }

        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)

        styleButton(leftButton)
        styleButton(rightButton)
        
        // Separator line below navigation
        bottomLine.backgroundColor = .theme(.lineGrey)
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        makeConstraints()
    }


    private func styleButton(_ button: UIButton) {
        
        // Установка тени
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 4

        // Установка фона
        button.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 46/255, alpha: 1)
        button.tintColor = .theme(.streakerGrey)

        // Установка градиента
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 0.8).cgColor,
            UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 0.5).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = button.bounds
        button.layer.insertSublayer(gradientLayer, at: 0)

        // Установка скругления и границы
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.22, green: 0.22, blue: 0.23, alpha: 1).cgColor
    }

    private func makeConstraints() {
        let scaleFactor = UIScreen.main.bounds.width / 375 // Width of iPhone SE screen
        let buttonWidth: CGFloat = 74 * scaleFactor
        let buttonHeight: CGFloat = 54 * scaleFactor

        leftButton.snp.makeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }

        rightButton.snp.makeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
    }

    func configure(title: String, leftButtonImage: UIImage?, rightButtonImage: UIImage?, hideBottomLine: Bool) {
        titleLabel.text = NSLocalizedString(title, comment: "")

        if let leftImage = leftButtonImage {
            leftButton.setImage(leftImage, for: .normal)
            leftButton.isHidden = false
        } else {
            leftButton.isHidden = true
        }

        if let rightImage = rightButtonImage {
            rightButton.setImage(rightImage, for: .normal)
            rightButton.isHidden = false
        } else {
            rightButton.isHidden = true
        }

        // Применение стиля после установки изображений
        styleButton(leftButton)
        styleButton(rightButton)
        
        bottomLine.isHidden = hideBottomLine
    }
}

extension UIImage {
    func scaled(to scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
}

class CustomNavigationController: UINavigationController {
    let customNavBar = CustomNavigationBar()
    var hideBottomLine: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
    }

    private func initViewController() {
        view.addSubview(customNavBar)
        
        customNavBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(80)
        }
    }

    func configureNavBar(title: String, leftButtonImage: UIImage?, rightButtonImage: UIImage?, leftAction: Selector?, rightAction: Selector?, target: Any?, hideBottomLine: Bool) {
        customNavBar.configure(title: title, leftButtonImage: leftButtonImage, rightButtonImage: rightButtonImage, hideBottomLine: hideBottomLine)
        
        if let leftAction = leftAction, let target = target {
            customNavBar.leftButton.addTarget(target, action: leftAction, for: .touchUpInside)
        }
        
        if let rightAction = rightAction, let target = target {
            customNavBar.rightButton.addTarget(target, action: rightAction, for: .touchUpInside)
        }
        
        customNavBar.bottomLine.isHidden = hideBottomLine
        
    }
}
