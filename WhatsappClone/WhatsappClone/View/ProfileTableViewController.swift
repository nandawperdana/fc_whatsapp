//
//  ProfileTableViewController.swift
//  WhatsappClone
//
//  Created by nandawperdana on 24/06/24.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Vars
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        setupUI()
    }

    // MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Navigate to chat screen
        if indexPath.section == 1 {
            print("Navigate to chat screen")
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        
        guard let user = self.user else { return }
        usernameLabel.text = user.username
        statusLabel.text = user.status
        
        if user.avatar != "" {
            FirebaseStorageHelper.downloadImage(url: user.avatar) { image in
                self.avatarImageView.image = image
            }
        }
    }
}
