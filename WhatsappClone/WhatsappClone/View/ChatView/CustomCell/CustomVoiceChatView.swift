//
//  CustomVoiceChatView.swift
//  WhatsappClone
//
//  Created by nandawperdana on 07/07/24.
//

import Foundation
import MessageKit

open class CustomVoiceChatView: MessageContentCell {
    // MARK: IBOutlets
    @IBOutlet weak var leftBubble: UIView!
    @IBOutlet weak var rightBubble: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var playImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        let nib = UINib(nibName: "CustomVoiceChatView", bundle: nil)
        
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        contentView.frame = self.messageContainerView.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.messageContainerView.addSubview(contentView)
    }
    
    open override func configure(with message: any MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        
        guard let mkMessage = message as? MKMessage else { return }
        
        delegate = messagesCollectionView.messageCellDelegate
        
        switch message.kind {
        case .audio(let audio):
            durationLabel.text = getDurationFormat(duration: audio.duration)
            infoLabel.text = getInfoText(mkMessage: mkMessage)
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
    
    func getDurationFormat(duration: Float) -> String {
        let minute = "\(Int(duration) / 60)"
        let second = "\(Int(duration) % 60 < 10 ? "0" : "")\(Int(duration) % 60)"
        return "\(minute):\(second)"
    }
    
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        delegate?.didTapMessage(in: self)
    }
}

open class CustomAudioMessageSizeCalculator: AudioMessageSizeCalculator {
    open override func messageContainerSize(for message: any MessageType) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message)
        let sizeForMediaItem = { (maxWidth: CGFloat, item: AudioItem) -> CGSize in
            return CGSize(width: 140, height: 64)
        }
        
        switch message.kind {
        case .audio(let item):
            return sizeForMediaItem(maxWidth, item)
        default:
            fatalError("undhandled media size \(message.kind)")
        }
    }
}
