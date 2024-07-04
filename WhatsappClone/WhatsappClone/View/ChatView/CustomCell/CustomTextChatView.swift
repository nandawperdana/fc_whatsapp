//
//  CustomTextViewCell.swift
//  WhatsappClone
//
//  Created by nandawperdana on 03/07/24.
//

import Foundation
import MessageKit

class CustomTextChatView: MessageContentCell {
    // MARK: IBOutlets
    @IBOutlet weak var leftBubbleView: UIView!
    @IBOutlet weak var rightBubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    static let chatViewFont = UIFont.systemFont(ofSize: 14)
    static let chatViewInset = UIEdgeInsets(top: 12, left: 12, bottom: 32, right: 12)
    
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
        
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        contentView.frame = self.messageContainerView.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.messageContainerView.addSubview(contentView)
    }
    
    override func configure(with message: any MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let mkMessage = message as? MKMessage else { return }
        
        switch message.kind {
        case .text(let text):
            messageLabel.text = text
            infoLabel.text = self.getInfoText(mkMessage: mkMessage)
        default:
            break
        }
        
        if (messagesCollectionView.messagesDataSource?.isFromCurrentSender(message: message) ?? true) {
            // Outgoing message
            leftBubbleView.isHidden = true
            rightBubbleView.isHidden = false
            bubbleView.backgroundColor = UIColor(named: "chat_outgoing")
            rightBubbleView.backgroundColor = UIColor(named: "chat_outgoing")
            leftBubbleView.backgroundColor = UIColor(named: "chat_outgoing")
            messageLabel.textColor = UIColor.black
        } else {
            // incoming message
            leftBubbleView.isHidden = false
            rightBubbleView.isHidden = true
            bubbleView.backgroundColor = UIColor(named: "chat_incoming")
            rightBubbleView.backgroundColor = UIColor(named: "chat_incoming")
            leftBubbleView.backgroundColor = UIColor(named: "chat_incoming")
        }
    }
    
    private func getInfoText(mkMessage: MKMessage) -> String {
        if mkMessage.status == kSent {
            return "\(mkMessage.sentDate.time()) · Sent"
        }
        if mkMessage.status == kRead {
            return "\(mkMessage.readDate.time()) · Read"
        }
        return ""
    }
}
