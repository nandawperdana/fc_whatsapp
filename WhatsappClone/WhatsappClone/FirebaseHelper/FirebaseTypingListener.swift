//
//  FirebaseTypingListener.swift
//  WhatsappClone
//
//  Created by nandawperdana on 05/07/24.
//

import Foundation
import Firebase

class FirebaseTypingListener {
    static let shared = FirebaseTypingListener()
    
    var typingListener: ListenerRegistration!
    
    private init() { }
    
    // MARK: Listen for typing
    func createTypingObserver(chatRoomId: String, completion: @escaping (_ isTyping: Bool) -> Void) {
        typingListener = FirebaseReference(.Typing).document(chatRoomId).addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else { return }
            
            if snapshot.exists {
                for data in snapshot.data()! {
                    if data.key != User.currentID {
                        completion(data.value as! Bool)
                    }
                }
            } else {
                completion(false)
                FirebaseReference(.Typing).document(chatRoomId).setData([User.currentID : false])
            }
        })
    }
    
    func saveTyping(typing: Bool, chatRoomId: String) {
        FirebaseReference(.Typing).document(chatRoomId).updateData([User.currentID : typing])
    }
    
    func removeTypingListener() {
        self.typingListener.remove()
    }
}
