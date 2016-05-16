//
//  PictureCollectionViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 12/05/16.
//
//

import UIKit


protocol PictureCollectionViewControllerDelegate{
    func currentPageIndex(page: Int, pagesCount: Int)
    func currentPageTitle(title: String)
}


class PictureCollectionViewController: UICollectionViewController {
    
    var delegate: PictureCollectionViewControllerDelegate?
    
    var cache: ImageCache = ImageCache()
    
    var character: Character?
    
    private var items = [Item]()
    
    
    
    var enableCloseButton = false
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        if let items = character?.comics.items{
            self.items = items
        }
        
        if enableCloseButton {
            // st up back button
            let closeButton = UIButton(frame: CGRectMake(self.view.frame.width - 50, 0, 50, 50))
            closeButton.setBackgroundImage(UIImage(named: "ImageClose"), forState: UIControlState.Normal)
            closeButton.addTarget(self, action: #selector(PictureCollectionViewController.handleCloseButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(closeButton)
        }
        
    }
    
    func handleCloseButton(recognizer: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.items.count>0{
            let item = self.items[0]
            delegate?.currentPageIndex(1, pagesCount: self.items.count)
            delegate?.currentPageTitle(item.name)
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
        
        if let imageView = cell.backgroundView as? UIImageView{
            //TODO: add placeholder
            imageView.image = nil
        }
        
        if let image = self.cache.get(hashValue) {
            
            if let imageView = cell.backgroundView as? UIImageView{
                imageView.image = image
            }else{
                
                let imageView = UIImageView(image: image)
                imageView.contentMode = .ScaleAspectFill
                cell.backgroundView = imageView
            }

        } else {
            
            Utilities.queues.asyncQueue.addOperationWithBlock({
                if let localImage = ImageUtilities.getImage(storagePath){
                    self.addImageToCacheAndRefreshItems(hashValue, image: localImage, indexPath: indexPath)
                }else{
                    let url = item.resourceURI
                    
                    MarvelRequest.getComic(url, completionHandler: { (ok: Bool, objects: [Comic]?, error: NSError?) in
                        if let comic = objects?.first{
                            ApiRepository().downloadImage(comic.thumbnailURI, storageFilePaths: storagePath, completionHandler: { (image) in
                                if image != nil{
                                    self.addImageToCacheAndRefreshItems(hashValue, image: image!, indexPath: indexPath)
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
    private func addImageToCacheAndRefreshItems(hashValue: Int, image: UIImage, indexPath: NSIndexPath){
        self.cache.add(hashValue, value: image)
        dispatch_async(dispatch_get_main_queue(), {
            if (self.collectionView?.cellForItemAtIndexPath(indexPath) != nil){
                self.collectionView?.reloadItemsAtIndexPaths([indexPath])
            }
        })
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let visibleRect = CGRect(origin: self.collectionView!.contentOffset, size: self.collectionView!.bounds.size)
        let visiblePoint = CGPoint(x: CGRectGetMidX(visibleRect), y: CGRectGetMidY(visibleRect))
        
        if let visibleIndexPath = self.collectionView?.indexPathForItemAtPoint(visiblePoint){
            
            let index = visibleIndexPath.row
            let item = self.items[index]
            
            delegate?.currentPageIndex(index+1, pagesCount: self.items.count)
            delegate?.currentPageTitle(item.name)
        }
        
    }
    
    
    
    
    
}