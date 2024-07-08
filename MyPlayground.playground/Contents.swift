import UIKit

func getChatRoomId(user1Id: String, user2Id: String) -> String {
    var chatRoomId = ""
    
    let value = user1Id.compare(user2Id).rawValue
    chatRoomId = value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
    
    return chatRoomId
}

print(getChatRoomId(user1Id: "1234", user2Id: "9876"))

// 12349876

print(getChatRoomId(user1Id: "9876", user2Id: "1234"))
