//
//  ChatViewController.swift
//  WhatsappClone
//
//  Created by nandawperdana on 29/06/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    // MARK: Vars
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    private var recipientAvatar = ""
    
    private var refreshController: UIRefreshControl = UIRefreshControl()
    
    // MARK: Input Bar Vars
    private var attachButton: InputBarButtonItem!
    private var photoButton: InputBarButtonItem!
    private var micButton: InputBarButtonItem!
    
    let currentUser = MKSender(senderId: User.currentID, displayName: User.currentUser!.username)
    var mkMessages: [MKMessage] = []
    
    // MARK: Inits
    init(chatId: String = "", recipientId: String = "", recipientName: String = "", recipientAvatar: String = "") {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
        self.recipientAvatar = recipientAvatar
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Config
        configureMessageCollectionView()
        configureMessageInputBar()
    }

    // MARK: Config UI
    private func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        messagesCollectionView.refreshControl = refreshController
    }
    
    private func configureMessageInputBar() {
        messageInputBar.delegate = self
//        messageInputBar.sendButton.title = ""
        
        // Text View
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.inputTextView.backgroundColor = UIColor.white
        messageInputBar.inputTextView.textColor = UIColor.black
        messageInputBar.inputTextView.layer.cornerRadius = 18
        messageInputBar.inputTextView.layer.borderWidth = 0.5
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Init Buttons
        attachButton = {
            let button = InputBarButtonItem()
            button.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            button.tintColor = UIColor.systemBlue
            button.setSize(CGSize(width: 24, height: 24), animated: false)
            return button
        }()
        
        photoButton = {
            let button = InputBarButtonItem()
            button.image = UIImage(systemName: "camera")
            button.tintColor = UIColor.systemBlue
            button.setSize(CGSize(width: 24, height: 24), animated: false)
            return button
        }()
        
        micButton = {
            let button = InputBarButtonItem()
            button.image = UIImage(systemName: "mic")
            button.tintColor = UIColor.systemBlue
            button.setSize(CGSize(width: 24, height: 24), animated: false)
            return button
        }()
        
        // On Buttons Tap
        attachButton.onTouchUpInside { item in
            print("attach")
        }
        
        photoButton.onTouchUpInside { item in
            print("attach")
        }
        
        micButton.onTouchUpInside { item in
            print("attach")
        }
        
        // Set button
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 24, animated: false)
//        messageInputBar.setStackViewItems([photoButton, micButton], forStack: .right, animated: false)
    }

}
