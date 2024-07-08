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
        
        // Photo Message type
        if let photo = photo {
            sendPictureMessage(message: message, photo: photo, memberIds: memberIds)
        }
        
        if let audio = audio {
            sendAudioMessage(message: message, audioFileName: audio, audioDuration: audioDuration, memberIds: memberIds)
        }
        
        // Send push notification
        PushNotificationService.shared.sendPushNotificationTo(userIds: removeCurrentUser(from: memberIds), body: message.message, chatRoomId: chatId)
        
        FirebaseRecentChatListener.shared.updateRecentChat(chatRoomId: chatId, lastMessage: message.message)
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

func sendPictureMessage(message: LocalMessage, photo: UIImage, memberIds: [String]) {
    message.message = "Picture Message"
    message.type = kPhoto
    
    // Get File
    let fileName = Date().stringDate()
    let fileDir = "MediaMessages/Photo/" + "\(message.chatRoomId)/" + "_\(fileName).jpg"
    
    // Upload File
    FirebaseStorageHelper.saveFileToLocal(file: photo.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)
    
    FirebaseStorageHelper.uploadImage(photo, directory: fileDir) { imageLink in
        if let url = imageLink {
            message.photoUrl = url
            OutgoingMessageHelper.sendMessage(message: message, memberIds: memberIds)
        }
    }
}

func sendAudioMessage(message: LocalMessage, audioFileName: String, audioDuration: Float, memberIds: [String]) {
    message.message = "Audio Message"
    message.type = kAudio
    
    // Get File
    let fileDir = "MediaMessages/Audio/" + "\(message.chatRoomId)/" + "_\(audioFileName).m4a"
    
    // Upload File
    FirebaseStorageHelper.uploadAudio(audioFileName, directory: fileDir) { audioLink in
        if let link = audioLink {
            message.audioUrl = link
            message.audioDuration = Double(audioDuration)
            
            OutgoingMessageHelper.sendMessage(message: message, memberIds: memberIds)
        }
    }
}
