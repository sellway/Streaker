//
//  NewStrakeViewController.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/28/23.
//

import UIKit

class NewStreakViewController: UIViewController {
    let mainView = NewStreakView()
    var strakeModel = NewStreakModel.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.listsTableView.delegate = self
        mainView.listsTableView.dataSource = self
        mainView.listsTableView.registerReusableCell(NewStreakCell.self)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.cancelButton)
        navigationItem.titleView = mainView.headerTitleLabel
        mainView.cancelButton.addTarget(self, action: #selector(dissmis), for: .touchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    @objc
    private func dissmis() {
        navigationController?.popViewController(animated: true)
    }
}

extension NewStreakViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        strakeModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewStreakCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = strakeModel[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.sizeH
    }
    
    
}
