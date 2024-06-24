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
        
        setupUI()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    // MARK: - Setup UI
    private func setupUI() {
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
