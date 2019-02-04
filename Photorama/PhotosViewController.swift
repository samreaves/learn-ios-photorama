//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Sam Reaves on 2/2/19.
//  Copyright © 2019 Sam Reaves Digital. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    var store: PhotoStore!
    var photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = photoDataSource
        
        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            
                switch photosResult {
                
                case let .success(photos):
                    print("Successfully found \(photos.count) photos")
                    self.photoDataSource.photos = photos
                
                case let .failure(error):
                    print("Error fetching photos: \(error)")
                }
            
                self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        /* Download the image data, which could take some time */
        store.fetchImage(for: photo) { (result) -> Void in

            /* The index path might have changed between the request starting and finishing */
            guard let photoIndex = (self.photoDataSource.photos).index(of: photo),
                case let .success(image) = result else {
                    return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            /* When the request finishes, only update the cell if it's still visible */
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "showPhoto"?:
                if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                    let photo = photoDataSource.photos[selectedIndexPath.row]
                    let destinationVC = segue.destination as! PhotoViewController
                    destinationVC.photo = photo
                    destinationVC.store = store
                }
            default:
                preconditionFailure("Invalid destination View Controller")
        }
    }
}
