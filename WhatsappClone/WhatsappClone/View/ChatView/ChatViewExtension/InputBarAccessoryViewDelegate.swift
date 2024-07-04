//
//  InputBarAccessoryViewDelegate.swift
//  WhatsappClone
//
//  Created by nandawperdana on 30/06/24.
//

import Foundation
import InputBarAccessoryView

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if !text.isEmpty {
        }
        
        self.updateRightButtonsStatus(text.isEmpty)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                sendMessage(text: text, photo: nil, video: nil, audio: nil)
            }
        }
        
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
}
