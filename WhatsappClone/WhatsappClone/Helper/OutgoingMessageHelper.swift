//
//  OutgoingMessageHelper.swift
//  WhatsappClone
//
//  Created by nandawperdana on 01/07/24.
//

import Foundation
import UIKit

class OutgoingMessageHelper {
    class func send(chatId: String, text: String?, photo: UIImage?, video: String?, audio: String?, audioDuration: Float = 0.0, memberIds: [String]) {
        guard let currentUser = User.currentUser else { return }
        
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderInitial = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSent
        
        // Text Message type
        if text != nil {
            sendTextMessage(message: message, text: text ?? "", memberIds: memberIds)
        }
        
        FirebaseRecentChatListener.shared.updateRecentChat(chatRoomId: chatId, lastMessage: text ?? "")
    }
    
    class func sendMessage(message: LocalMessage, memberIds: [String]) {
        // Save message to realm
        DBManager.shared.saveToRealm(message)
        
        // Send message/save to firebase
        for id in memberIds {
            FirebaseMessageListener.shared.saveMessage(message, memberId: id)
        }
    }
}

func sendTextMessage(message: LocalMessage, text: String, memberIds: [String]) {
    message.message = text
    message.type = kText
    OutgoingMessageHelper.sendMessage(message: message, memberIds: memberIds)
}
