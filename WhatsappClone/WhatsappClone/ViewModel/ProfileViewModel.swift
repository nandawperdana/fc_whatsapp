//
//  ProfileViewModel.swift
//  WhatsappClone
//
//  Created by nandawperdana on 08/07/24.
//

import Foundation
import UIKit

class ProfileViewModel {
    // MARK: Vars
    var user: User
    
    // MARK: Getters
    var status: String {
        return user.status
    }
    
    var userName: String {
        if (user.firstName != nil && user.lastName != nil) && (user.firstName != "" && user.lastName != "") {
            return "\(user.firstName!) \(user.lastName!)"
        }
        return user.username
    }
    
    // MARK: Init
    init(user: User) {
        self.user = user
    }
    
    // MARK: Business Logic
    func fetchAvatarImage(completion: @escaping (UIImage?) -> Void) {
        if !user.avatar.isEmpty {
            FirebaseStorageHelper.downloadImage(url: user.avatar) { image in
                completion(image?.circleMasked)
            }
        }
    }
    
    func navigateToChatVC(completion: @escaping (ChatViewController) -> Void) {
        guard let currentUser = User.currentUser else { return }
        
        let chatRoomId = StartChatHelper.shared.startChat(user1: currentUser, user2: user)
        let chatVC = ChatViewController(chatId: chatRoomId, recipientId: user.id, recipientName: user.username, recipientAvatar: user.avatar)
        
        completion(chatVC)
    }
}
