//
//  FirebaseStorageHelper.swift
//  WhatsappClone
//
//  Created by nandawperdana on 23/06/24.
//

import Foundation
import UIKit
import FirebaseStorage
import ProgressHUD

class FirebaseStorageHelper {
    
    // MARK: - Image Helper
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ imageLink: String?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: kStorageReference).child(directory)
        
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(imageData!, metadata: nil, completion: { metadata, error in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("error uploading image \(error!.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let url = url else {
                    completion(nil)
                    return
                }
                
                completion(url.absoluteString)
            }
        })
        
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.progress(CGFloat(progress))
        }
    }
    
    class func downloadImage(url: String, completion: @escaping (_ image: UIImage?) -> Void) {
        let imageFileName = fileNameFrom(url)
        
        if fileExistsAtPath(imageFileName) {
            if let file = UIImage(contentsOfFile: fileDocumentsDirectory(fileName: imageFileName)) {
                completion(file)
            }
        } else {
            if url != "" {
                let fileUrl = URL(string: url)
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                
                downloadQueue.async {
                    let data = NSData(contentsOf: fileUrl!)
                    
                    if data != nil {
                        FirebaseStorageHelper.saveFileToLocal(file: data!, fileName: imageFileName)
                        
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Audio Helper
    class func uploadAudio(_ audioFileName: String, directory: String, completion: @escaping (_ audioLink: String?) -> Void) {
        let fileName = audioFileName + ".m4a"
        
        let storageRef = Storage.storage().reference(forURL: kStorageReference).child(directory)
            
        var task: StorageUploadTask!
        
        if fileExistsAtPath(fileName) {
            if let audioData = NSData(contentsOfFile: fileDocumentsDirectory(fileName: fileName)) {
                
                task = storageRef.putData(audioData as Data, metadata: nil, completion: { metadata, error in
                    task.removeAllObservers()
                    ProgressHUD.dismiss()
                    
                    if error != nil {
                        print("error uploading audio \(error!.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        guard let url = url else {
                            completion(nil)
                            return
                        }
                        
                        completion(url.absoluteString)
                    }
                })
                
                task.observe(StorageTaskStatus.progress) { snapshot in
                    let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
                    ProgressHUD.progress(CGFloat(progress))
                }
            } else {
                print("No Audio File Found")
            }
        }
    }
    
    class func downloadAudio(url: String, completion: @escaping (_ audioFileName: String) -> Void) {
        let audioFileName = fileNameFrom(url) + ".m4a"
        
        if fileExistsAtPath(audioFileName) {
            completion(audioFileName)
        } else {
            if url != "" {
                let fileUrl = URL(string: url)
                let downloadQueue = DispatchQueue(label: "audioDownloadQueue")
                
                downloadQueue.async {
                    let data = NSData(contentsOf: fileUrl!)
                    
                    if data != nil {
                        FirebaseStorageHelper.saveFileToLocal(file: data!, fileName: audioFileName)
                        
                        DispatchQueue.main.async {
                            completion(audioFileName)
                        }
                    } else {
                        print("No Document Found")
                    }
                }
            }
        }
    }
    
    // MARK: - Save to Local
    class func saveFileToLocal(file: NSData, fileName: String) {
        let fileUrl = getDocumentsUrl().appendingPathComponent(fileName, isDirectory: false)
        file.write(to: fileUrl, atomically: true)
    }
}
