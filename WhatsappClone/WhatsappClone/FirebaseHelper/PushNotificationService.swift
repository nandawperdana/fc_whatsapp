//
//  PushNotificationService.swift
//  WhatsappClone
//
//  Created by nandawperdana on 08/07/24.
//

import Foundation

class PushNotificationService {
    static let shared = PushNotificationService()
    
    private init() { }
    
    func sendPushNotificationTo(userIds: [String], body: String, chatRoomId: String) {
        // Send push to users
        FirebaseUserListener.shared.downloadUsersFromFirestore(withIds: userIds) { allUsers in
            for user in allUsers {
                let title = User.currentUser?.username ?? "User"
                
                // Send push
                self.sendMessage(to: user.pushId, title: title, body: body, chatRoomId: chatRoomId)
            }
        }
    }
    
    private func sendMessage(to token: String, title: String, body: String, chatRoomId: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        
        let url = NSURL(string: urlString)!
        
        let params: [String : Any] = [
            "to" : token,
            "notification" : [
                "title" : title,
                "body" : body,
                "badge" : "1",
                "sound" : "default"
            ]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(kServerKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        
        task.resume()
    }
}
