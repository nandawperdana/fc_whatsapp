//
//  User.swift
//  WhatsappClone
//
//  Created by nandawperdana on 06/06/24.
//

import Foundation

struct User: Codable, Equatable {
    var id = ""
    var username: String
    var email: String
    var pushId = ""
    var avatar = ""
    var firstName: String?
    var lastName: String?
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
