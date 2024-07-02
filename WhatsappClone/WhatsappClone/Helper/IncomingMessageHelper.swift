//
//  IncomingMessageHelper.swift
//  WhatsappClone
//
//  Created by nandawperdana on 02/07/24.
//

import Foundation
import MessageKit

class IncomingMessageHelper {
    var messageVC: MessagesViewController
    
    init(messageVC: MessagesViewController) {
        self.messageVC = messageVC
    }
    
    // MARK: Create message
    func createMessage(localMessage: LocalMessage) -> MKMessage? {
        let mkMessage = MKMessage(message: localMessage)
        
        return mkMessage
    }
}
