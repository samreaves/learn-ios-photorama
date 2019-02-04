//
//  PhotoViewController.swift
//  Photorama
//
//  Created by Sam Reaves on 2/3/19.
//  Copyright © 2019 Sam Reaves Digital. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImage(for: photo) { (result) -> Void in
            switch result {
            case let .success(image):
                self.imageView.image = image
            
            case let .failure(error):
                print("Error fetching image in PhotoViewController: \(error)")
            }
        }
    }
}
