//
//  MainView.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/25/23.
//

import UIKit
import SnapKit

class MainView {
    
    let addButton: UIButton = {
        let obj = UIButton()
        if let originalImage = UIImage(named: "leftButton"),
           let scaledImage = originalImage.scaled(to: 1.1) {
            obj.setImage(scaledImage, for: .normal)
        }
        obj.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 46/255, alpha: 1)
        obj.tintColor = .theme(.streakerGrey)
        obj.layer.cornerRadius = 12
        obj.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
        obj.layer.borderWidth = 0.2
        return obj
    }()
    
    let settingsButton: UIButton = {
        let obj = UIButton()
        if let originalImage = UIImage(named: "rightButton"),
           let scaledImage = originalImage.scaled(to: 1.1) {
            obj.setImage(scaledImage, for: .normal)
        }
        obj.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 46/255, alpha: 1)
        obj.tintColor = .theme(.streakerGrey)
        obj.layer.cornerRadius = 12
        obj.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
        obj.layer.borderWidth = 0.2
        return obj
    }()

     init() {
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtonsToSuperview(_ superview: UIView) {
            superview.addSubview(addButton)
            superview.addSubview(settingsButton)
            makeConstraints()
        }
}

//MARK: setup
extension MainView {
    private func setup() {
        styleButton(addButton)
        styleButton(settingsButton)
        makeConstraints()
    }
    
    private func styleButton(_ button: UIButton) {
            // Установка тени
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.4
            button.layer.shadowOffset = CGSize(width: 0, height: 3)
            button.layer.shadowRadius = 4
            
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
            let buttonHeight: CGFloat = 54 * scaleFactor // If you want to scale the height as well
        
            addButton.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
            }

            settingsButton.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
            }
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

