//
//  SettingsTableViewController.swift
//  WhatsappClone
//
//  Created by nandawperdana on 22/06/24.
//

import Foundation
import UIKit
import FirebaseAuth


class SettingsTableViewController: UITableViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchUserInfo()
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "editProfileSegue", sender: self)
        }
    }
    
    // MARK: - IBActions
    @IBAction func tellAFriendButtonTap(_ sender: Any) {
        print("tell a friend")
    }
    
    @IBAction func logoutButtonTap(_ sender: Any) {
        FirebaseUserListener.shared.logoutUser { error in
            if error == nil {
                let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginView")
                
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Update UI
    private func fetchUserInfo() {
        if let user = User.currentUser {
            userNameLabel.text = user.username
            statusLabel.text = user.status
            
            if user.avatar != "" {
                FirebaseStorageHelper.downloadImage(url: user.avatar) { image in
                    self.avatarImageView.image = image
                }
            }
        }
    }
}
