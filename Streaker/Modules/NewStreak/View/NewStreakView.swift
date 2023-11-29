//
//  NewStrakeView.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/28/23.
//

import UIKit
import SnapKit

class NewStreakView: UIView {
    
    let headerTitleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "New Strake"
        obj.textColor = .white
        obj.textAlignment = .left
        obj.font = UIFont.systemFont(ofSize: 20.sizeW, weight: .bold)
        return obj
    }()
    
    let topButton: UIView = {
       let obj = UIView()
        obj.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 40/255, alpha: 1)
        obj.layer.cornerRadius = 26
        obj.clipsToBounds = true
        return obj
    }()
    
    let clearButton: UIButton = {
       let obj = UIButton()
        obj.backgroundColor = .clear
        return obj
    }()
    
    let btnIcon: UIImageView = {
       let obj = UIImageView()
        obj.image = .theme(.plus)
        return obj
    }()
    
    let titleLabel: UILabel = {
       let obj = UILabel()
        
        obj.text = "Create your own streak"
        obj.textColor = .white
        obj.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return obj
    }()
    
    let cancelButton: UIButton = {
        let obj = UIButton()
        obj.setImage(UIImage(named: "leftArrow"), for: .normal)
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
        obj.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 40/255, alpha: 1)
        obj.layer.cornerRadius = 26
        return obj
    }()
    
    let selectTitle: UILabel = {
        let obj = UILabel()
        
        obj.text = "Or select from these topics"
        obj.textColor = .white
        obj.font = UIFont.systemFont(ofSize: 17, weight: .medium)
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
extension NewStreakView {
    private func setup() {
        addSubview(listsTableView)
        addSubview(topButton)
        addSubview(selectTitle)
        topButton.addSubview(clearButton)
        clearButton.addSubview(btnIcon)
        clearButton.addSubview(titleLabel)
        self.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        topButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64.sizeH)
        }
        
        selectTitle.snp.makeConstraints { make in
            make.top.equalTo(topButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        listsTableView.snp.makeConstraints { make in
            make.top.equalTo(selectTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.size.width.equalTo(74.sizeW)
            make.size.height.equalTo(54.sizeH)
        }
        
        clearButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        btnIcon.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(21)
            make.width.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(btnIcon.snp.trailing).offset(12)
        }
    }
}
