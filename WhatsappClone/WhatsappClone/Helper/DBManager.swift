//
//  DBManager.swift
//  WhatsappClone
//
//  Created by nandawperdana on 01/07/24.
//

import Foundation
import RealmSwift

class DBManager {
    static let shared = DBManager()
    let realm = try! Realm()
    
    private init() { }
    
    func saveToRealm<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            print("Error while saving object to Realm ", error.localizedDescription)
        }
    }
}
