//
//  FCollectionReference.swift
//  WhatsappClone
//
//  Created by nandawperdana on 11/06/24.
//

import Foundation
import Firebase

enum FCollectionReference: String {
    case User
    case Recent
    case Message
    case Typing
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
