//
//  StatsView.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/28/23.
//

import UIKit
import SnapKit

class StatsView: UIView {
    
    let closeButton: UIButton = {
        let obj = UIButton()
        obj.setImage(UIImage(named: "greenCloseButton"), for: .normal)
        obj.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 46/255, alpha: 1)
        obj.tintColor = .theme(.streakerGrey)
        obj.layer.cornerRadius = 12
        obj.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
        obj.layer.borderWidth = 0.2
        return obj
    }()
    
    let headerTitleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "Stats"
        obj.textColor = .white
        obj.textAlignment = .left
        obj.font = UIFont.systemFont(ofSize: 20.sizeW, weight: .bold)
        return obj
    }()
    
    private lazy var testImage: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(named: "testStats")
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

//MARK: setup
extension StatsView {
    private func setup() {
        
        addSubview(testImage)

        self.backgroundColor = .theme(.streakerGrey)
        makeConstraints()
    }
    
    private func makeConstraints() {

        testImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.size.width.equalTo(74.sizeW)
            make.size.height.equalTo(54.sizeH)
        }
        
    }
}
