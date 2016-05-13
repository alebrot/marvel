//
//  PictureCollectionViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 12/05/16.
//
//

import UIKit

class PictureCollectionViewController: UICollectionViewController {
    
    var cache: ImageCache = ImageCache()
    
    var character: Character?
    
    private var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = character?.comics.items{
            self.items = items
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.cache.clear()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.items.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Config.TableView.CellIdentifiers.ItemCell, forIndexPath: indexPath)

        let item = items[indexPath.row]
        
        let hashValue = item.hashValue
        let storagePath = Config.StorageFilePaths.resourceComicsPath(String(hashValue))
        

        if let image = self.cache.get(hashValue) {
            cell.backgroundView = UIImageView(image: image)
        } else {
            
            Utilities.queues.asyncQueue.addOperationWithBlock({
                if let localImage = ImageUtilities.getImage(storagePath){
                    self.addImageToCacheAndRefreshItems(localImage, indexPath: indexPath)
                }else{
                    let url = item.resourceURI
                    
                    MarvelRequest.getComic(url, completionHandler: { (ok: Bool, objects: [Comic]?, error: NSError?) in
                        if let comic = objects?.first{
                            ApiRepository().downloadImage(comic.thumbnailURI, storageFilePaths: storagePath, completionHandler: { (image) in
                                if image != nil{
                                    self.addImageToCacheAndRefreshItems(image!, indexPath: indexPath)
                                }
                            })
                        }
                    })
                    
                }
            })
        }
        
        // Configure the cell
        return cell
    }
    private func addImageToCacheAndRefreshItems(image: UIImage, indexPath: NSIndexPath){
        self.cache.add(hashValue, value: image)
        dispatch_async(dispatch_get_main_queue(), {
            if (self.collectionView?.cellForItemAtIndexPath(indexPath) != nil){
                self.collectionView?.reloadItemsAtIndexPaths([indexPath])
            }
        })
    }

}

