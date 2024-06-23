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
    
    // MARK: - Save to Local
    class func saveFileToLocal(file: NSData, fileName: String) {
        let fileUrl = getDocumentsUrl().appendingPathComponent(fileName, isDirectory: false)
        file.write(to: fileUrl, atomically: true)
    }
}
