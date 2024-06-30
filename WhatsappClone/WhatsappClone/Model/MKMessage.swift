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
    
    init(message: LocalMessage) {
        self.messageId = message.id
        self.kind = MessageKind.text(message.message)
        self.sentDate = message.date
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.senderInitial = message.senderInitial
        self.status = message.status
        self.readDate = message.readDate
        self.isIncoming = User.currentID != mkSender.senderId
        
//        switch message.type {
//            case ""
//        }
    }
}
