//
//  MyStreaksView.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 5/3/24.
//

import UIKit

class MyStreaksView: UIView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}

