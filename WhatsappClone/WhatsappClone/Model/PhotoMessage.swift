//
//  PhotoMessage.swift
//  WhatsappClone
//
//  Created by nandawperdana on 07/07/24.
//

import Foundation
import MessageKit

class PhotoMessage: NSObject, MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(url: URL? = nil, image: UIImage? = nil, placeholderImage: UIImage, size: CGSize) {
        self.url = url
        self.image = image
        self.placeholderImage = placeholderImage
        self.size = size
    }
    
    init(path: String) {
        self.url = URL(fileURLWithPath: path)
        self.placeholderImage = UIImage(systemName: "photo")!
        self.size = CGSize(width: 240, height: 240)
    }
}
