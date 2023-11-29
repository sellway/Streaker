//
//  SettingsViewController.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/25/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let mainView = SettingsScreenView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }

}
