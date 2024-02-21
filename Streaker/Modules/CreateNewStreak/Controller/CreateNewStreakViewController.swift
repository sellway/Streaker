//
//  CreateNewStreakViewController.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 20/2/24.
//

import UIKit

class CreateNewStreakViewController: UIViewController {
    let createNewStreakView = CreateNewStreakView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        // Add the createNewStreakView as a subview and set up constraints
        view.addSubview(createNewStreakView)
        createNewStreakView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        // Customize navigation bar if needed
        navigationItem.title = "New Streak"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "leftArrow"),
            style: .plain,
            target: self,
            action: #selector(dismissViewController)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveStreak)
        )
    }
    
    @objc private func dismissViewController() {
        // Dismiss or pop the view controller
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveStreak() {
        // Save the new streak with the name from the text field
        let streakName = createNewStreakView.streakNameTextField.text ?? ""
        print("Saving streak with name: \(streakName)")
        // Here you would save the streak to your data model or database
    }
}
