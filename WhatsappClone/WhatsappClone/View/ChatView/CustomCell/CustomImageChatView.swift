//
//  CustomImageChatView.swift
//  WhatsappClone
//
//  Created by nandawperdana on 07/07/24.
//

import Foundation
import UIKit
import MessageKit

class CustomImageChatView: MessageContentCell {
    // MARK: IBOutlets
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var leftBubble: UIView!
    @IBOutlet weak var rightBubble: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
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
        let nib = UINib(nibName: "CustomImageChatView", bundle: nil)
        
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        contentView.frame = self.messageContainerView.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.messageContainerView.addSubview(contentView)
    }
    
    override func configure(with message: any MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let mkMessage = message as? MKMessage else { return }
        
        delegate = messagesCollectionView.messageCellDelegate
        
        switch message.kind {
        case .photo(let photo):
            // Set image
            imageView.image = photo.image
            infoLabel.text = self.getInfoText(mkMessage: mkMessage)
        default:
            break
        }
        
        if (messagesCollectionView.messagesDataSource?.isFromCurrentSender(message: message) ?? true) {
            // Outgoing message
            leftBubble.isHidden = true
            rightBubble.isHidden = false
            customView.backgroundColor = UIColor(named: "chat_outgoing")
            rightBubble.backgroundColor = UIColor(named: "chat_outgoing")
            leftBubble.backgroundColor = UIColor(named: "chat_outgoing")
        } else {
            // incoming message
            leftBubble.isHidden = false
            rightBubble.isHidden = true
            customView.backgroundColor = UIColor(named: "chat_incoming")
            rightBubble.backgroundColor = UIColor(named: "chat_incoming")
            leftBubble.backgroundColor = UIColor(named: "chat_incoming")
        }
    }
    
    private func getInfoText(mkMessage: MKMessage) -> String {
        if mkMessage.mkSender.senderId == User.currentID {
            if mkMessage.status == kSent {
                return "\(mkMessage.sentDate.time()) · Sent"
            }
            if mkMessage.status == kRead {
                return "\(mkMessage.readDate.time()) · Read"
            }
        }
        return mkMessage.readDate.time()
    }
    
    override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        delegate?.didTapImage(in: self)
    }
}

open class CustomMediaMessageSizeCalculator: MediaMessageSizeCalculator {
    open override func messageContainerSize(for message: MessageType) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message)
        let sizeForMediaItem = { (maxWidth: CGFloat, item: MediaItem) -> CGSize in
            let width = (item.image?.size.width ?? 10) > maxWidth - 42 ? maxWidth - 42 : (item.image?.size.width ?? 10)
            let height = (width / (item.image?.size.width ?? 10)) * (item.image?.size.height ?? 10)
            return CGSize(width: width + 24, height: height + 24 + 32)
        }
        
        switch message.kind {
        case .photo(let item):
            return sizeForMediaItem(maxWidth, item)
        default:
            fatalError("undhandled media size \(message.kind)")
        }
    }
}
