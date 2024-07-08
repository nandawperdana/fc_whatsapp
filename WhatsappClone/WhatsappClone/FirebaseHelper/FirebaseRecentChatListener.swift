//
//  FirebaseRecentChatListener.swift
//  WhatsappClone
//
//  Created by nandawperdana on 27/06/24.
//

import Foundation

class FirebaseRecentChatListener {
    static let shared = FirebaseRecentChatListener()
    
    private init() {}
    
    // MARK: - Download Recent Chats
    func downloadRecentChatsFromFirestore(completion: @escaping (_ recentChats: [RecentChat]) -> Void) {
        FirebaseReference(.Recent).whereField(kSenderId, isEqualTo: User.currentID).addSnapshotListener { snapshot, error in
            var recentChats: [RecentChat] = []
            
            guard let documents = snapshot?.documents else {
                print("No documents")
                completion(recentChats)
                return
            }
            
            let allRecentChats = documents.compactMap { document in
                return try? document.data(as: RecentChat.self)
            }
            
            for recent in allRecentChats {
                if !recent.lastMessage.isEmpty {
                    recentChats.append(recent)
                }
            }
            
            completion(recentChats)
        }
    }
    
    // MARK: - Save Recent Chat
    func saveRecentChat(_ recentChat: RecentChat) {
        do {
            try FirebaseReference(.Recent).document(recentChat.id).setData(from: recentChat)
        } catch {
            print("Error save recent chat ", error.localizedDescription)
        }
    }
    
    // MARK: - Update Recent Chat
    func updateRecentChat(chatRoomId: String, lastMessage: String) {
        FirebaseReference(.Recent).whereField(kChatRoomId, isEqualTo: chatRoomId).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No Documents Found")
                return
            }
            
            let allRecents = documents.compactMap { snapshot in
                return try? snapshot.data(as: RecentChat.self)
            }
            
            for recent in allRecents {
                // Update Last Message
                self.updateRecentWithNewMessage(recent: recent, lastMessage: lastMessage)
            }
        }
    }
    
    private func updateRecentWithNewMessage(recent: RecentChat, lastMessage: String) {
        var tempRecent = recent
        
        if tempRecent.senderId != User.currentID {
            tempRecent.unreadCounter += 1
        }
        
        tempRecent.lastMessage = lastMessage
        tempRecent.date = Date()
        
        self.saveRecentChat(tempRecent)
    }
    
    // MARK: - update unread counter
    func resetRecentChatCounter(chatRoomId: String) {
        FirebaseReference(.Recent).whereField(kChatRoomId, isEqualTo: chatRoomId).whereField(kSenderId, isEqualTo: User.currentID).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No Documents Found")
                return
            }
            
            let allRecents = documents.compactMap { snapshot in
                return try? snapshot.data(as: RecentChat.self)
            }
            
            if allRecents.count > 0 {
                self.clearUnreadCounter(recentChat: allRecents.first!)
            }
        }
    }
    
    func clearUnreadCounter(recentChat: RecentChat) {
        var newRecentChat = recentChat
        newRecentChat.unreadCounter = 0
        self.saveRecentChat(newRecentChat)
    }
    
    func delete(recentChat: RecentChat) {
        FirebaseReference(.Recent).document(recentChat.id).delete()
    }
}
