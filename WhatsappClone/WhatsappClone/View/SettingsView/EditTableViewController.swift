//
//  EditTableViewController.swift
//  WhatsappClone
//
//  Created by nandawperdana on 23/06/24.
//

import UIKit

class EditTableViewController: UITableViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        
        configureUsernameTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchUserInfo()
    }
    
    // MARK: - IBActions
    
    @IBAction func editButtonTap(_ sender: Any) {
    }
    
    // MARK: - Update UI
    private func fetchUserInfo() {
        if let user = User.currentUser {
            usernameTextField.text = user.username
            statusLabel.text = ""
            
            if user.avatar != "" {
                // Set profile picture
            }
        }
    }
    
    private func configureUsernameTextField() {
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EditTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            guard textField.text != "" else { return false }
            
            if var user = User.currentUser {
                user.username = textField.text!
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFirestore(user)
            }
        }
        
        textField.resignFirstResponder()
        return false
    }
}
