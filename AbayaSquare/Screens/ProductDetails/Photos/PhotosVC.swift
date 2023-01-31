//
//  PhotosVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/27/21.
//

import UIKit
import SKPhotoBrowser
import Kingfisher

class PhotosVC: UIViewController {
    
    @IBOutlet weak var imagesCV: UICollectionView!
    @IBOutlet weak var smallImagesCV: UICollectionView!
    
    var imagesString: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCV.register(nibName: PhotosCell.identifier)
        smallImagesCV.register(nibName: PhotosCell.identifier)
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
}

extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesString.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.identifier, for: indexPath) as! PhotosCell
        cell.productImage.setImage(url: imagesString[indexPath.row])
        if collectionView == imagesCV {
            cell.productImage.enableZoom()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imagesCV {
            return collectionView.frame.size
        } else {
            return CGSize(width: 130, height: 170)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        
        if collectionView == smallImagesCV {
            imagesCV.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .left, animated: true)
        } else {
            var images = [SKPhoto]()
            for image in 0..<(imagesString.count) {
                let photo = SKPhoto.photoWithImageURL(imagesString[image])
                photo.contentMode = .scaleAspectFit
                images.append(photo)
            }
            SKPhotoBrowserOptions.displayAction = false
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(indexPath.row)
            present(browser, animated: true, completion: {})
        }
    }
}
