//
//  User.swift
//  WhatsappClone
//
//  Created by nandawperdana on 06/06/24.
//

import Foundation
import Firebase

struct User: Codable, Equatable {
    var id = ""
    var username: String
    var status: String
    var email: String
    var pushId = ""
    var avatar = ""
    var firstName: String?
    var lastName: String?
    
    // MARK: - Helpers
    static var currentID: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let userDict = UserDefaults.standard.data(forKey: kCurrentUser) {
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: userDict)
                    return userObject
                } catch {
                    print("Failed to decode userObject", error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

func saveUserLocally(_ user: User) {
    let encoder = JSONEncoder()
    
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: kCurrentUser)
    } catch {
        print("Failed to encode userObject", error.localizedDescription)
    }
}

func createDummyUsers() {
    print("Creating dummy users...")
    
    let names = ["Alex", "Budi", "Cinta", "Dewa", "Eli"]
    
    var imageIdx = 1
    var userIdx = 1
    
    for i in 0..<5 {
        let id = UUID().uuidString
        
        let fileDirectory = "Avatars/" + "_\(id)" + ".jpg"
        
        let image = UIImage(named: "user\(imageIdx)")!
        
        FirebaseStorageHelper.uploadImage(image, directory: fileDirectory) { imageLink in
            let user = User(id: id, username: names[i], status: "Available", email: "user\(userIdx)@mail.com", avatar: imageLink ?? "")
            
            userIdx += 1
            FirebaseUserListener.shared.saveUserToFirestore(user)
        }
        
        imageIdx += 1
        if imageIdx == 5 {
            imageIdx = 1
        }
    }
}
