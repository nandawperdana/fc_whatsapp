//
//  ContactsTableViewCell.swift
//  WhatsappClone
//
//  Created by nandawperdana on 24/06/24.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(user: User) {
        usernameLabel.text = user.username
        statusLabel.text = user.status
        setAvatar(avatar: user.avatar)
    }
    
    private func setAvatar(avatar: String) {
        guard avatar != "" else { return }
        
        FirebaseStorageHelper.downloadImage(url: avatar) { image in
            self.avatarImageView.image = image?.circleMasked
        }
    }
}
