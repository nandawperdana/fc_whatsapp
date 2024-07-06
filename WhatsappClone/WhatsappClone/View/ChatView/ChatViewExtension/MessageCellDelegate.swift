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
}
