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
                
                case let .failure(error):
                    print("Error fetching photos: \(error)")
                }
            
        }
    }
}
