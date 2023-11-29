//
//  ProfileViewController.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/26/23.
//

import UIKit
import MessageUI


class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {
    let mainView = ProfileView()
    var profileModel = ProfileModel.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewController()
        
        mainView.listsTableView.delegate = self
        mainView.listsTableView.dataSource = self
        mainView.listsTableView.registerReusableCell(ProfileButtonCell.self)
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
        
    }
    
    private func initViewController() {
        setupHeader()
    }
    
    private func setupHeader() {
        navigationItem.titleView = mainView.headerTitleLabel
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.cancelButton)
        
        mainView.cancelButton.addTarget(self, action: #selector(canelButtonTapped), for: .touchUpInside)
    }
    
    @objc private func canelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func showPauseAlert() {
        let alertController = UIAlertController(
            title: nil,
            message: "Are you sure you want to pause everything?",
            preferredStyle: .alert
        )

        let yesAction = UIAlertAction(
            title: "Yes",
            style: .default,
            handler: { _ in
              
            }
        )

        let noAction = UIAlertAction(
            title: "No",
            style: .destructive,
            handler: { _ in
                
            }
        )

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }

    func openMessageWindow() {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail Service is NOT available")
            
            let errorController = UIAlertController(title: "Dear User", message: "Sorry, but Write To Us Service is temporarily unavailable. Please try again later.", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            errorController.addAction(okAction)
            present(errorController, animated: true)
            
            return
        } else {
            
            print("Mail Service IS working")
            
            let composeController = MFMailComposeViewController()
            composeController.mailComposeDelegate = self
            
            composeController.setToRecipients(["stakeYourSkillsFeedback@gmail.com"])
            composeController.setSubject("Message Subject")
            composeController.setMessageBody("Message content", isHTML: false)
            
            self.present(composeController, animated: true, completion: nil)
        }
    }

    
}

//MARK: TableView

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProfileButtonCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = profileModel[indexPath.row]
        cell.backgroundColor = .theme(.streakerGrey)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.sizeH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        switch row {
        case 0:
            print(0)
            let vc = NewStreakViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            print(1)
        case 2:
            print(2)
        case 3:
            print(3)
            showPauseAlert()
        case 4:
            print(4)
            openMessageWindow()
        case 5:
            print(5)
            let vc = SettingsViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("")
        }
    }
}
