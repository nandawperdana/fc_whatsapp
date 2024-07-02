//
//  CustomTextChatView.swift
//  WhatsappClone
//
//  Created by nandawperdana on 02/07/24.
//

import UIKit
import MessageKit

class CustomTextChatView: MessageContentCell {
    // MARK: IBOutlets
    @IBOutlet weak var leftBubbleView: UIView!
    @IBOutlet weak var rightBubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    static let chatViewFont = UIFont.systemFont(ofSize: 14)
    static let chatViewInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        let nib = UINib(nibName: "CustomTextChatView", bundle: nil)
        
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        contentView.frame = self.messageContainerView.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.messageContainerView.addSubview(contentView)
    }
    
    override func configure(with message: any MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .text(let text):
            messageLabel.text = text
            infoLabel.text = message.sentDate.time()
    default:
        break
        }
    }
}
