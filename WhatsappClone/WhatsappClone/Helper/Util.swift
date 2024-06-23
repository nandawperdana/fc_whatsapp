//
//  Util.swift
//  WhatsappClone
//
//  Created by nandawperdana on 23/06/24.
//

import Foundation

func fileNameFrom(_ url: String) -> String {
    let fileName = ((url.components(separatedBy: "_").last)?.components(separatedBy: "?").first)?.components(separatedBy: ".").first
    return fileName ?? ""
}

func fileExistsAtPath(_ fileName: String) -> Bool {
    return FileManager.default.fileExists(atPath: fileDocumentsDirectory(fileName: fileName))
}

func fileDocumentsDirectory(fileName: String) -> String {
    return getDocumentsUrl().appendingPathComponent(fileName).path
}

func getDocumentsUrl() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}
