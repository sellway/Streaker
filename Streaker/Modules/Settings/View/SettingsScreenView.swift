//
//  SetingsScreenView.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/25/23.
//

import UIKit
import SnapKit

class SettingsScreenView: UIView {
    
    private var navBarHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNavBarHeight(_ height: CGFloat) {
        self.navBarHeight = height
        setNeedsLayout()
    }
    
    private func setup() {
        //addSubview(tableView)
        self.backgroundColor = .theme(.backgroundMain)
    }
    
}
