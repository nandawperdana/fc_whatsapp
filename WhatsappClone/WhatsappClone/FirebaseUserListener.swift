//
//  FirebaseUserListener.swift
//  WhatsappClone
//
//  Created by nandawperdana on 11/06/24.
//

import Foundation
import Firebase

class FirebaseUserListener {
    static let shared = FirebaseUserListener()
    
    private init() {}
    
    // MARK: - Login
    func loginUser(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        // Call firebase function for authentication (login)
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            // check for error
            if let e = error {
                completion(e, false)
                return
            }
            
            // get the auth data result
            // safely check with guard
            guard let user = authDataResult?.user else {
                completion(NSError(), false)
                return
            }
            
            // Download user data
            FirebaseUserListener.shared.downloadUserFromFirestore(userId: user.uid, email: email)
            
            // Call completion
            completion(nil, user.isEmailVerified)
        }
        
    }
    
    // MARK: - Register
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        // Call firebase function for authentication (register)
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            // check for error
            if let e = error {
                completion(e)
                return
            }
            
            // get the auth data result
            // safely check with guard
            guard let user = authDataResult?.user else {
                completion(NSError())
                return
            }
            
            // Send email verification
            self.sendEmailVerificationTo(user)
            
            // Save user info to UserDefaults
            self.saveUser(email: email, uid: user.uid)
            
            completion(nil)
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String, completion: @escaping (_ error: Error?) -> Void) {
        // Firebase Auth
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    // Function for send email verification
    private func sendEmailVerificationTo(_ user: FirebaseAuth.User) {
        user.sendEmailVerification { error in
            if let e = error {
                print("Error sending email verification: ", e.localizedDescription)
            } else {
                print("Success sent email verification")
            }
        }
    }
    
    // Function to save user to UserDefaults
    private func saveUser(email: String, uid: String) {
        // Create object of User
        let user = User(id: uid, username: email, email: email, avatar: "", firstName: "", lastName: "")
        
        // Save user to UserDefaults
        saveUserLocally(user)
        
        // Save Firestore
        saveUserToFirestore(user)
    }
    
    // Function to save user to Firestore
    private func saveUserToFirestore(_ user: User) {
        do {
            try FirebaseReference(.User).document(user.id).setData(from: user)
        } catch {
            print("Error save user to firestore ", error.localizedDescription)
        }
    }
    
    // MARK: - Download
    func downloadUserFromFirestore(userId: String, email: String? = nil) {
        // Call firebase function to download user data
        FirebaseReference(.User).document(userId).getDocument { snapshot, error in
            
            guard let document = snapshot else {
                print("No document found")
                return
            }
            
            // Download data
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObj):
                if let user = userObj {
                    // Save user data to UserDefaults
                    saveUserLocally(user)
                } else {
                    print("No User found")
                }
            case .failure(let error):
                print("Error encoding User data, ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Logout
    func logoutUser(completion: @escaping (_ error: Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: kCurrentUser)
            UserDefaults.standard.synchronize()
            
            completion(nil)
        } catch let error as NSError {
            completion(error)
        }
    }
}
