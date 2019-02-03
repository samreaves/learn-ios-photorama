//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Sam Reaves on 2/2/19.
//  Copyright © 2019 Sam Reaves Digital. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            
                switch photosResult {
                
                case let .success(photos):
                    print("Successfully found \(photos.count) photos")
                    if let firstPhoto = photos.first {
                        self.updateImageView(for: firstPhoto)
                    }
                
                case let .failure(error):
                    print("Error fetching photos: \(error)")
                }
            
        }
    }
    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) {
            (imageResult) in
            switch imageResult {
                case let .success(image):
                    self.imageView.image = image
                case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
}
