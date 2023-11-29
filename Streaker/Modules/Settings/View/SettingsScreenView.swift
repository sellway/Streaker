//
//  SetingsScreenView.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/25/23.
//

import UIKit
import SnapKit

class SettingsScreenView: UIView {
    let headerTitleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "hints_header".localized()
        obj.textColor = .white
        obj.textAlignment = .center
        obj.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return obj
    }()
    
    private lazy var testTitle: UILabel = {
        let obj = UILabel()
        obj.text = "Test SettingsViewController"
        obj.textColor = .white
        return obj
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsScreenView {
    private func setup() {
        addSubview(testTitle)
        self.backgroundColor = .theme(.streakerGrey)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        testTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
