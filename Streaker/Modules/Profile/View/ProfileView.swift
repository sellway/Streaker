//
//  ProfileView.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/26/23.
//

import UIKit
import SnapKit

class ProfileView: UIView {
    
    let headerTitleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "profile_header".localized()
        obj.textColor = .white
        obj.textAlignment = .left
        obj.font = UIFont.systemFont(ofSize: 20.sizeW, weight: .bold)
        return obj
    }()
    
    let cancelButton: UIButton = {
        let obj = UIButton()
        obj.setImage(UIImage(named: "cancelButton"), for: .normal)
        obj.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 46/255, alpha: 1)
        obj.tintColor = .theme(.streakerGrey)
        obj.layer.cornerRadius = 12
        obj.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor
        obj.layer.borderWidth = 0.2
        return obj
    }()
    
    let listsTableView: UITableView = {
        let obj = UITableView()
        obj.showsVerticalScrollIndicator = false
        obj.showsHorizontalScrollIndicator = false
        obj.backgroundColor = .clear
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
extension ProfileView {
    private func setup() {
        addSubview(listsTableView)        
        self.backgroundColor = .theme(.streakerGrey)
        makeConstraints()
    }
    
    private func makeConstraints() {
        listsTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.size.width.equalTo(74.sizeW)
            make.size.height.equalTo(54.sizeH)
        }
    }
}
