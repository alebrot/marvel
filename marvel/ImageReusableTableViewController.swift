//
//  ImageReusableTableViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 10/05/16.
//
//

import UIKit

class ImageReusableTableViewController<T, C: UITableViewCell>: ReusableTableViewController<T, C> {
    
    var caches: [ImageCache]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caches = [ImageCache]()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        for cache: ImageCache in self.caches{
            cache.clear()
        }
    }
    
    
    func getImageHashForObject(object: T, atIndexPath indexPath: NSIndexPath)->Int{
        return 0
    }
    
    func placeholderForImageView(imageView: UIImageView, andObject object: T, indexPath: NSIndexPath) -> UIImage? {
        return nil
    }
    
    func image(imageView: UIImageView, object: T, indexPath: NSIndexPath, completionHandler: (image:UIImage?) -> Void) -> UIImage? {
        return nil
    }
    
    func imageViewsForCell(cell: C, andObject object: T, indexPath: NSIndexPath) -> [UIImageView]{
        return []
    }
    
    override func inflateCell(cell: C, forObject object: T, atIndexPath indexPath: NSIndexPath) {
        
        super.inflateCell(cell, forObject: object, atIndexPath: indexPath)
        
        let imageViews = self.imageViewsForCell(cell, andObject: object, indexPath: indexPath)
        
        if (imageViews.count>0) {
            
            if (self.caches.count < imageViews.count) {
                for _ in (self.caches.count-1)...(imageViews.count-1) {
                    self.caches.append(ImageCache())
                }
                
            }
            
            for index in 0...(imageViews.count-1){
                let imageView = imageViews[index]
                imageView.tag = index
                self.inflateImageView(imageView, forObject: object, indexPath: indexPath, withCache: self.caches[index])
            }
        }
        
        
        
        
    }
    
    private func inflateImageView(imageView: UIImageView, forObject object: T, indexPath: NSIndexPath, withCache cache: ImageCache){
        
        let hashValue =  self.getImageHashForObject(object, atIndexPath: indexPath)
        
        if let image = cache.get(hashValue) {
            imageView.image = image
        } else {
            //set placeholder and proceed
            imageView.image = self.placeholderForImageView(imageView, andObject: object, indexPath: indexPath)
            
            Utilities.queues.asyncQueue.addOperationWithBlock({
                () -> Void in
                
                if let localImage = self.image(imageView, object: object, indexPath:indexPath, completionHandler: {
                    (image: UIImage?) -> Void in
                    if (image != nil) {
                        
                        cache.add(hashValue, value: image!)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            if self.tableView.cellForRowAtIndexPath(indexPath) != nil {
                                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                            }
                            
                        })
                        
                    }
                }) {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        imageView.image = localImage
                    })
                    
                }
                
            })
        }
        
        
    }
    
}

class ImageCache{
    private var cache: [Int:UIImage]
    
    init() {
        self.cache = [Int: UIImage]()
    }
    
    func add(hash: Int, value: UIImage) {
        self.cache[hash] = value
    }
    func get(hash: Int)->UIImage? {
        return self.cache[hash]
    }
    
    func clear() {
        self.cache.removeAll()
    }
}