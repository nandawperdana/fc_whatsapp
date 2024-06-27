//
//  StartChatHelper.swift
//  WhatsappClone
//
//  Created by nandawperdana on 27/06/24.
//

import Foundation
import Firebase

class StartChatHelper {
    static let shared = StartChatHelper()
    
    private init() { }
    
    // MARK: - Start Chat
    func startChat(user1: User, user2: User) -> String {
        let chatRoomId = getChatRoomId(user1Id: user1.id, user2Id: user2.id)
        
        print("Creating chat room \(chatRoomId)")
        // create recent items
        createRecentChatItems(chatRoomId: chatRoomId, users: [user1, user2])
        
        return chatRoomId
    }
    
    func createRecentChatItems(chatRoomId: String, users: [User]) {
        guard !users.isEmpty else { return }
        
        var memberIdsToCreateRecentChat = [users.first!.id, users.last!.id]
        
        // Check user have recent chat
        FirebaseReference(.Recent).whereField(kChatRoomId, isEqualTo: chatRoomId).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                // Remove user who has recent chat
                memberIdsToCreateRecentChat = self.removeUserWhoHasRecentChat(snapshot: snapshot, memberIds: memberIdsToCreateRecentChat)
            }
            
            guard let currentUser = User.currentUser else { return }
            
            for id in memberIdsToCreateRecentChat {
                
                print("Creating recent chat for id \(id)")
                
                let senderUser = id == currentUser.id ? currentUser : self.getReceiverUser(users: users)
                
                let receiverUser = id == currentUser.id ? self.getReceiverUser(users: users) : currentUser
                
                let recentChat = RecentChat(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.username, receiverID: receiverUser.id, receiverName: receiverUser.username, date: Date(), lastMessage: "", unreadCounter: 0, avatar: receiverUser.avatar)
                
                // Store to firebase
                FirebaseRecentChatListener.shared.saveRecentChat(recentChat)
            }
        }
    }
    
    func getChatRoomId(user1Id: String, user2Id: String) -> String {
        var chatRoomId = ""
        
        let value = user1Id.compare(user2Id).rawValue
        chatRoomId = value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
        
        return chatRoomId
    }
    
    func removeUserWhoHasRecentChat(snapshot: QuerySnapshot, memberIds: [String]) -> [String] {
        var memberIdsToCreateRecentChat = memberIds
        
        for data in snapshot.documents {
            let currentRecent = data.data() as Dictionary
            
            if let currentUserId = currentRecent[kSenderId] {
                let userId = currentUserId as! String
                
                if memberIdsToCreateRecentChat.contains(userId) {
                    let idx = memberIdsToCreateRecentChat.firstIndex(of: userId)!
                    memberIdsToCreateRecentChat.remove(at: idx)
                }
            }
        }
        
        return memberIdsToCreateRecentChat
    }
    
    func getReceiverUser(users: [User]) -> User {
        var allUsers = users
        
        guard let currentUser = User.currentUser else { return allUsers.first! }
        
        allUsers.remove(at: allUsers.firstIndex(of: currentUser)!)
        
        return allUsers.first!
    }
}
