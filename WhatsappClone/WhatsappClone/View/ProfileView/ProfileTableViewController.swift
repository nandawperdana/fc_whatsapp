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
    var viewModel: ProfileViewModel!
    
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
            viewModel.navigateToChatVC { chatVC in
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        usernameLabel.text = viewModel.userName
        statusLabel.text = viewModel.status
        viewModel.fetchAvatarImage { avatar in
            self.avatarImageView.image = avatar
        }
    }
}
