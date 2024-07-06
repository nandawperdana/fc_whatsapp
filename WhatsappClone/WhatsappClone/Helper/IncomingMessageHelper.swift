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
        
        if localMessage.type == kPhoto {
            let photoItem = PhotoMessage(path: localMessage.photoUrl)
            
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            FirebaseStorageHelper.downloadImage(url: localMessage.photoUrl) { image in
                mkMessage.photoItem?.image = image
                self.messageVC.messagesCollectionView.reloadData()
            }
        }
        
        if localMessage.type == kAudio {
            
        }
        
        return mkMessage
    }
}
