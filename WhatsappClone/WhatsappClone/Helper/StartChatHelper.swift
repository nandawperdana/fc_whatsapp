//
//  StartChatHelper.swift
//  WhatsappClone
//
//  Created by nandawperdana on 27/06/24.
//

import Foundation

class StartChatHelper {
    // MARK: - Start Chat
    func startChat(user1: User, user2: User) -> String {
        let chatRoomId = getChatRoomId(user1Id: user1.id, user2Id: user2.id)
        
        // create recent items
        createRecentChatItems(chatRoomId: chatRoomId, users: [user1, user2])
        
        return chatRoomId
    }
    
    func createRecentChatItems(chatRoomId: String, users: [User]) {
        // Check user have recent chat
        FirebaseReference(.Recent).whereField(kChatRoomId, isEqualTo: chatRoomId).getDocuments { snaptshot, error in
            
        }
    }
    
    func getChatRoomId(user1Id: String, user2Id: String) -> String {
        var chatRoomId = ""
        
        let value = user1Id.compare(user2Id).rawValue
        chatRoomId = value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
        
        return chatRoomId
    }
}
