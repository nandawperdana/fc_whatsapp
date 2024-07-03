//
//  Extension.swift
//  WhatsappClone
//
//  Created by nandawperdana on 26/06/24.
//

import Foundation

extension Date {
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
