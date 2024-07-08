//
//  RecentChatTableViewCell.swift
//  WhatsappClone
//
//  Created by nandawperdana on 26/06/24.
//

import UIKit

class RecentChatTableViewCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var recentMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unreadCounterLabel: UILabel!
    @IBOutlet weak var unreadCounterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unreadCounterView.layer.cornerRadius = unreadCounterView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Configure Cell
    func configure(recent: RecentChat) {
        usernameLabel.text = recent.receiverName
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.5
        
        recentMessageLabel.text = recent.lastMessage
        recentMessageLabel.adjustsFontSizeToFitWidth = true
        recentMessageLabel.numberOfLines = 2
        recentMessageLabel.minimumScaleFactor = 0.9
        
        if recent.unreadCounter != 0 {
            self.unreadCounterLabel.text = "\(recent.unreadCounter)"
            self.unreadCounterView.isHidden = false
        } else {
            self.unreadCounterView.isHidden = true
        }
        
        setAvatar(avatar: recent.avatar)
        if let date = recent.date {
            dateLabel.isHidden = false
            dateLabel.text = timeElapsed(date: date)
        } else {
            dateLabel.isHidden = true
        }
        dateLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setAvatar(avatar: String) {
        guard avatar != "" else { return }
        
        FirebaseStorageHelper.downloadImage(url: avatar) { image in
            self.avatarImageView.image = image?.circleMasked
        }
    }
}
