//
//  FirebaseMessageListener.swift
//  WhatsappClone
//
//  Created by nandawperdana on 01/07/24.
//

import Foundation
import Firebase

class FirebaseMessageListener {
    static let shared = FirebaseMessageListener()
    
    private init() { }
    
    // MARK: Save, Update, Delete Message
    func saveMessage(_ message: LocalMessage, memberId: String) {
        do {
            try FirebaseReference(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch {
            print("Error when saving message to Firebase ", error.localizedDescription)
        }
    }
    
    // MARK: Fetch Old Message
    func fetchOldMessage(_ documentId: String, collectionId: String) {
        FirebaseReference(.Message).document(documentId).collection(collectionId).getDocuments { snapashot, error in
            guard let documents = snapashot?.documents else {
                print("No documents found")
                return
            }
            
            var messages = documents.compactMap { snapshot -> LocalMessage? in
                return try? snapshot.data(as: LocalMessage.self)
            }
            
            messages.sort(by:  { $0.date < $1.date })
            
            for message in messages {
                DBManager.shared.saveToRealm(message)
            }
        }
    }
}
