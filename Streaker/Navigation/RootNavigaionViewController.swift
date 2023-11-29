//
//  RootNavigaionViewController.swift
//  Streaker
//
//  Created by Volodymyr Kolomyltsev on 11/25/23.
//

import Foundation
import UIKit

class RootNavigationViewController: UINavigationController {
    init() {
        let mainScreenVC = MainViewController()
        super.init(rootViewController: mainScreenVC)
        isNavigationBarHidden = false
        setupNavigationBarAppearance()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor.clear
        appearance.backgroundImage = UIImage()
        
        appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
