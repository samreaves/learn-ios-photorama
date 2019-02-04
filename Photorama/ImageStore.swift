//
//  ImageStore.swift
//  Photorama
//
//  Created by Sam Reaves on 1/19/19.
//  Copyright © 2019 Sam Reaves Digital. All rights reserved.
//

import UIKit

class ImageStore {
    
    /* Cache will store images by string key */
    let cache = NSCache<NSString, UIImage>()
    
    /* Add image to cache */
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        let imageURL = getImageURL(forKey: key)

        /* Turn image into JPEG data */
        if let data = image.jpegData(compressionQuality: 0.5) {
            let _ = try? data.write(to: imageURL, options: [.atomic])
        }
    }
    
    /* Get image from cache */
    func image(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        let url = getImageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path)
            else {
                return nil
            }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    /* Delete image */
    func deleteImage(forKey key: String) -> Bool {
        cache.removeObject(forKey: key as NSString)
        
        let URL = getImageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: URL)
            return true
        } catch let deleteError{
            print("Error removing image form the disk: \(deleteError)")
            return false
        }
    }
    
    /* Get Image URL for writing/reading from file */
    func getImageURL(forKey key: String) -> URL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories[0]
        
        return documentDirectory.appendingPathComponent(key)
    }
}
