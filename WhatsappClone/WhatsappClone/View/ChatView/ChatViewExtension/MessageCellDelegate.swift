//
//  MessageCellDelegate.swift
//  WhatsappClone
//
//  Created by nandawperdana on 30/06/24.
//

import Foundation
import MessageKit
import SKPhotoBrowser

extension ChatViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            let mkMessage = mkMessages[indexPath.section]
            
            if let image = mkMessage.photoItem?.image {
                var images = [SKPhoto]()
                let photo = SKPhoto.photoWithImage(image)
                images.append(photo)
                
                let browser = SKPhotoBrowser(photos: images)
                browser.initializePageIndex(0)
                
                self.present(browser, animated: true)
            }
        }
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            let mkMessage = mkMessages[indexPath.section]
            
            if let audio = mkMessage.audioItem {
                guard audioController.state != .stopped else {
                    audioController.playSound(for: mkMessage, in: cell as! CustomVoiceChatView)
                    return
                }
                
                if audioController.playingMessage?.messageId == mkMessage.messageId {
                    if audioController.state == .playing {
                        audioController.pauseSound(for: mkMessage, in: cell as! CustomVoiceChatView)
                    } else {
                        audioController.resumeSound()
                    }
                } else {
                    audioController.stopAnyOngoingPlaying()
                    audioController.playSound(for: mkMessage, in: cell as! CustomVoiceChatView)
                }
            }
        }
    }
}
