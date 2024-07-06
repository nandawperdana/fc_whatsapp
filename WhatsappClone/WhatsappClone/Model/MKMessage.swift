//
//  MKMessage.swift
//  WhatsappClone
//
//  Created by nandawperdana on 30/06/24.
//

import Foundation
import MessageKit

class MKMessage: NSObject, MessageType {
    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var mkSender: MKSender
    var sender: SenderType { return mkSender }
    var senderInitial: String
    
    var status: String
    var readDate: Date
    var isIncoming: Bool
    
    var photoItem: PhotoMessage?
//    var audioItem: AudioMessage?
    
    init(message: LocalMessage) {
        self.messageId = message.id
        self.kind = MessageKind.text(message.message)
        self.sentDate = message.date
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.senderInitial = message.senderInitial
        self.status = message.status
        self.readDate = message.readDate
        self.isIncoming = User.currentID != mkSender.senderId
        
        switch message.type {
        case kText:
            self.kind = MessageKind.text(message.message)
        case kPhoto:
            let photoItem = PhotoMessage(path: message.photoUrl)
            self.kind = MessageKind.photo(photoItem)
            self.photoItem = photoItem
//        case kAudio:
//            let audioItem = AudioMessage()
//            self.kind = MessageKind.audio(audioItem)
//            self.audioItem = audioItem
        default:
            self.kind = MessageKind.text(message.message)
        }
    }
}
