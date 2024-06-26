//
//  Util.swift
//  WhatsappClone
//
//  Created by nandawperdana on 23/06/24.
//

import Foundation

// MARK: - File Utils
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


// MARK: - Date Utils
func timeElapsed(date: Date) -> String {
    let seconds = Date().timeIntervalSince(date)
    
    var elapsed = ""
    
    if seconds < 60 {
        elapsed = "Just now"
    } else if seconds < 60 * 60 {
        let minutes = Int(seconds/60)
        let minText = minutes > 1 ? "mins" : "min"
        elapsed = "\(minutes) \(minText)"
    } else if seconds < 24 * 60 * 60 {
        let hours = Int(seconds / (60*60))
        let hourText = hours > 1 ? "hours" : "hour"
        elapsed = "\(hours) \(hourText)"
    } else {
        elapsed = date.longDate()
    }
    
    return elapsed
}
