//
//  ChatViewController.swift
//  WhatsappClone
//
//  Created by nandawperdana on 29/06/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import RealmSwift

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
    
    // MARK: Header Vars
    private var headerView: UIView!
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var avatarView: UIImageView!
    
    let realm = try! Realm()
    
    let currentUser = MKSender(senderId: User.currentID, displayName: User.currentUser!.username)
    var mkMessages: [MKMessage] = []
    var allLocalMessages: Results<LocalMessage>!
    
    var typingCounter = 0
    
    // MARK: Paging
    var maxMessageNumber = 0
    var minMessageNumber = 0
    var displayMessageCount = 0
    
    // MARK: Listener
    var notificationToken: NotificationToken?
    
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
        configureHeaderView()
        configureBackgroundView()
        configureMessageCollectionView()
        configureMessageInputBar()
        configureCustomCell()
        
        // Load Chat
        loadChats()
        listenForNewChat()
        createTypingObserver()
        
        // Typing status
        updateTypingStatus(false)
        
        listenForReadStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseRecentChatListener.shared.resetRecentChatCounter(chatRoomId: chatId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FirebaseRecentChatListener.shared.resetRecentChatCounter(chatRoomId: chatId)
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
            button.setSize(CGSize(width: 32, height: 32), animated: false)
            return button
        }()
        
        micButton = {
            let button = InputBarButtonItem()
            button.image = UIImage(systemName: "mic")
            button.tintColor = UIColor.systemBlue
            button.setSize(CGSize(width: 32, height: 32), animated: false)
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
        messageInputBar.sendButton.image = UIImage(systemName: "paperplane.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        messageInputBar.sendButton.title = ""
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 24, animated: false)
        updateRightButtonsStatus(true)
    }
    
    func updateRightButtonsStatus(_ active: Bool) {
        if active {
            messageInputBar.setStackViewItems([photoButton, micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 72, animated: false)
        } else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 24, animated: false)
        }
    }
    
    private func configureCustomCell() {
        messagesCollectionView.register(CustomTextChatView.self)
        
        let textCellCalc = messagesCollectionView.messagesCollectionViewFlowLayout.textMessageSizeCalculator
        textCellCalc.messageLabelFont = CustomTextChatView.chatViewFont
        textCellCalc.incomingMessageLabelInsets = CustomTextChatView.chatViewInset
        textCellCalc.outgoingMessageLabelInsets = CustomTextChatView.chatViewInset
        
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingAvatarSize(.zero)
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingAvatarSize(.zero)
    }
    
    private func configureHeaderView() {
        headerView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        titleLabel = {
            let view = UILabel()
            view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            view.textColor = .black
            view.translatesAutoresizingMaskIntoConstraints = false
            view.adjustsFontSizeToFitWidth = true
            return view
        }()
        
        subTitleLabel = {
            let view = UILabel()
            view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            view.textColor = .darkGray
            view.translatesAutoresizingMaskIntoConstraints = false
            view.adjustsFontSizeToFitWidth = true
            return view
        }()
        
        avatarView = {
            let view = UIImageView(image: UIImage(named: "person.circle.fill")?.circleMasked)
            view.contentMode = .scaleToFill
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // Add views
        headerView.addSubview(titleLabel)
        headerView.addSubview(subTitleLabel)
        headerView.addSubview(avatarView)
        
        self.navigationItem.titleView = headerView
        
        // Constraints
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 36),
            avatarView.heightAnchor.constraint(equalToConstant: 36),
            avatarView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 0),
            avatarView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            subTitleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
        ])
        
        if let navBar = self.navigationController?.navigationBar {
            headerView.widthAnchor.constraint(equalToConstant: navBar.frame.width).isActive = true
            headerView.heightAnchor.constraint(equalToConstant: navBar.frame.height).isActive = true
        }
        
        // Set data
        titleLabel.text = recipientName
        subTitleLabel.text = "Tap here for contact info"
        if !recipientAvatar.isEmpty {
            FirebaseStorageHelper.downloadImage(url: recipientAvatar) { image in
                self.avatarView.image = image?.circleMasked
            }
        }
        
        // Header view action
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onHeaderViewTap))
        headerView.addGestureRecognizer(gesture)
    }
    
    private func configureBackgroundView() {
        // Setup Background View
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "bg_chat")
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        messagesCollectionView.backgroundView = bgImageView
        
        // Setup Constraints
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: messagesCollectionView.topAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: messagesCollectionView.bottomAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: messagesCollectionView.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: messagesCollectionView.trailingAnchor),
        ])
    }
    
    // MARK: Actions
    func sendMessage(text: String?, photo: UIImage?, video: String?, audio: String?, audioDuration: Float = 0.0) {
        OutgoingMessageHelper.send(chatId: chatId, text: text, photo: photo, video: video, audio: audio, memberIds: [User.currentID, recipientId])
    }
    
    @objc func onHeaderViewTap() {
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileView") as! ProfileTableViewController
        
        FirebaseUserListener.shared.getUser(by: recipientId) { user in
            profileView.user = user
            self.navigationController?.pushViewController(profileView, animated: true)
        }
    }
    
    // MARK: Load Chats
    private func loadChats() {
        let predicate = NSPredicate(format: "\(kChatRoomId) = %@", chatId)
        
        // Fetch from Realm
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDate, ascending: true)
        
        if allLocalMessages.isEmpty {
            // Fetch from Firebase
            fetchOldMessage()
        }
        
        notificationToken = allLocalMessages.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.createMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            case .update(_, _, let insertion, _):
                for idx in insertion {
                    self.createMessage(self.allLocalMessages[idx])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: false)
                }
            case .error(let error):
                print("error when listening messsage ", error.localizedDescription)
            }
        })
    }
    
    private func fetchOldMessage() {
        FirebaseMessageListener.shared.fetchOldMessage(User.currentID, collectionId: chatId)
    }
    
    private func fetchMoreMessage(maxNumber: Int, minNumber: Int) {
        maxMessageNumber = minNumber - 1
        minMessageNumber = maxMessageNumber - kLimitMessageFetch
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in (minMessageNumber ... maxMessageNumber).reversed() {
            // create message
            createOlderMessage(allLocalMessages[i])
        }
    }
    
    private func createMessages() {
        maxMessageNumber = allLocalMessages.count - displayMessageCount
        minMessageNumber = maxMessageNumber - kLimitMessageFetch
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in minMessageNumber ..< maxMessageNumber {
            createMessage(allLocalMessages[i])
        }
    }
    
    private func createMessage(_ message: LocalMessage) {
        if message.senderId != User.currentID {
            // Update Read Status
            markMessageAsRead(message)
        }
        
        let helper = IncomingMessageHelper(messageVC: self)
        if let newMessage = helper.createMessage(localMessage: message) {
            mkMessages.append(newMessage)
            displayMessageCount += 1
        }
    }
    
    private func createOlderMessage(_ message: LocalMessage) {
        let helper = IncomingMessageHelper(messageVC: self)
        if let newMessage = helper.createMessage(localMessage: message) {
            self.mkMessages.insert(newMessage, at: 0)
            displayMessageCount += 1
        }
    }
    
    private func markMessageAsRead(_ message: LocalMessage) {
        if message.senderId != User.currentID && message.status != kRead {
            FirebaseMessageListener.shared.updateMessage(message, memberIds: [User.currentID, recipientId])
        }
    }
    
    private func listenForNewChat() {
        FirebaseMessageListener.shared.listenForNewChat(User.currentID, collectionId: chatId, lastMessageDate: lastMessageDate())
    }
    
    private func listenForReadStatus() {
        FirebaseMessageListener.shared.listenForReadStatus(User.currentID, collectionId: chatId) { updatedMessage in
            if updatedMessage.status != kSent {
                self.updateMessage(updatedMessage)
            }
        }
    }
    
    // MARK: Typing Listener
    private func createTypingObserver() {
        FirebaseTypingListener.shared.createTypingObserver(chatRoomId: chatId) { isTyping in
            DispatchQueue.main.async {
                self.updateTypingStatus(isTyping)
            }
        }
    }
    
    func updateTypingCounter() {
        typingCounter += 1
        
        FirebaseTypingListener.shared.saveTyping(typing: true, chatRoomId: chatId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.stopTypingCounter()
        }
    }
    
    func stopTypingCounter() {
        typingCounter -= 1
        
        if typingCounter == 0 {
            FirebaseTypingListener.shared.saveTyping(typing: false, chatRoomId: chatId)
        }
    }
    
    private func updateTypingStatus(_ typing: Bool) {
        self.subTitleLabel.text = typing ? "Typing..." : "Tap here for contact info"
    }
    
    private func updateMessage(_ message: LocalMessage) {
        for idx in 0 ..< mkMessages.count {
            if message.id == mkMessages[idx].messageId {
                mkMessages[idx].status = message.status
                mkMessages[idx].readDate = message.readDate
                
                DBManager.shared.saveToRealm(message)
                
                if mkMessages[idx].status == kRead {
                    self.messagesCollectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: Helpers
    private func lastMessageDate() -> Date {
        let lastMessageDate = allLocalMessages.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second, value: 1, to: lastMessageDate) ?? lastMessageDate
    }
    
    // MARK: UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshController.isRefreshing {
            if displayMessageCount < allLocalMessages.count {
                // Fetch more data
                fetchMoreMessage(maxNumber: maxMessageNumber, minNumber: minMessageNumber)
                messagesCollectionView.reloadDataAndKeepOffset()
            }
            
            refreshController.endRefreshing()
        }
    }
}
