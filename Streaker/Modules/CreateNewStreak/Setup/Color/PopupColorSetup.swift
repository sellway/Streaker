//  PopupColorSetup.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 12/7/24.
//

import UIKit
import SnapKit

protocol PopupColorSetupDelegate: AnyObject {
    func didSelectColor(_ color: UIColor)
}

class PopupColorSetup: UIViewController {
    
    weak var delegate: PopupColorSetupDelegate?
    var selectedColor: UIColor = .yellowRegular
    var onColorSelected: ((UIColor) -> Void)?
    
    // Define the colors array as a property of the class
    private let colors: [UIColor] = [
        .yellowRegular, .redRegular, .orangeRegular,
        .blueRegular, .lilacRegular, .greenRegular,
        .purpleRegular, .pinkRegular, .violetRegular
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurEffect()
        setupPopup()
        setupCloseButton()
        addDismissGesture()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let colorGridView = view.viewWithTag(101) {
            if let selectedIndex = colors.firstIndex(of: selectedColor) {
                selectColor(at: selectedIndex, from: colorGridView)
            }
        }
    }

    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    private func setupPopup() {
        let popupView = UIView()
        popupView.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 40/255, alpha: 1)
        popupView.layer.cornerRadius = 12
        popupView.tag = 100
        view.addSubview(popupView)

        // Setup constraints for popupView
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(343)
            make.height.equalTo(354)
        }

        let titleLabel = UILabel()
        titleLabel.text = "Choose the color"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .white
        popupView.addSubview(titleLabel)

        // Setup constraints for titleLabel
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
        }

        let colorGridView = UIView()
        colorGridView.tag = 101 // Добавляем tag для colorGridView
        popupView.addSubview(colorGridView)

        // Setup constraints for colorGridView
        colorGridView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(240)
        }

        let colorSize = 64
        let colorSpacing = 24

        for (index, color) in colors.enumerated() {
            let colorView = UIView()
            colorView.backgroundColor = color
            colorView.layer.cornerRadius = 16
            colorView.layer.masksToBounds = true
            colorView.tag = index
            colorView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped(_:)))
            colorView.addGestureRecognizer(tapGesture)
            colorGridView.addSubview(colorView)

            let row = index / 3
            let col = index % 3

            // Setup constraints for colorView
            colorView.snp.makeConstraints { make in
                make.size.equalTo(colorSize)
                make.leading.equalToSuperview().offset(col * (colorSize + colorSpacing))
                make.top.equalToSuperview().offset(row * (colorSize + colorSpacing))
            }

            // Add circle to the center of the color view
            let circleView = UIView()
            circleView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            circleView.layer.cornerRadius = 16
            circleView.layer.masksToBounds = true
            colorView.addSubview(circleView)

            // Setup constraints for circleView
            circleView.snp.makeConstraints { make in
                make.size.equalTo(32)
                make.center.equalToSuperview()
            }
        }
    }


    
    @objc private func colorTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        let colorGridView = tappedView.superview
        selectColor(at: tappedView.tag, from: colorGridView!)
    }
    
    private func selectColor(at index: Int, from gridView: UIView) {
        for subview in gridView.subviews {
            let colorView = subview
            let isSelected = colorView.tag == index
            if isSelected {
                selectedColor = colors[colorView.tag]
                delegate?.didSelectColor(selectedColor)  // Notify the delegate
            }
            colorView.layer.borderWidth = isSelected ? 4 : 0
            colorView.layer.borderColor = isSelected ? selectedColor.cgColor : nil
            if let circleView = colorView.subviews.first {
                circleView.backgroundColor = isSelected ? selectedColor : UIColor.white.withAlphaComponent(0.3)
            }
            colorView.backgroundColor = isSelected ? .clear : colors[colorView.tag]
        }
    }
    
    private func setupCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "greyCross"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        view.addSubview(closeButton)
        
        // Настройка констрейнтов для closeButton
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(56)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func closePopup() {
            // Pass the selected color back before closing
            onColorSelected?(selectedColor)
            self.dismiss(animated: true, completion: nil)
        }
    
    private func addDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
            let location = sender.location(in: view)
            if view.viewWithTag(100)?.frame.contains(location) == false {
                closePopup()
            }
        }
}

extension UIColor {
    static let redRegular = UIColor(named: "redRegular")!
    static let orangeRegular = UIColor(named: "orangeRegular")!
    static let yellowRegular = UIColor(named: "yellowRegular")!
    static let blueRegular = UIColor(named: "blueRegular")!
    static let lilacRegular = UIColor(named: "lilacRegular")!
    static let greenRegular = UIColor(named: "greenRegular")!
    static let purpleRegular = UIColor(named: "purpleRegular")!
    static let pinkRegular = UIColor(named: "pinkRegular")!
    static let violetRegular = UIColor(named: "violetRegular")!
}





