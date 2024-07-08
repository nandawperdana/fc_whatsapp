//
//  MKSender.swift
//  WhatsappClone
//
//  Created by nandawperdana on 30/06/24.
//

import Foundation
import MessageKit

struct MKSender: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
