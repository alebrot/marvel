//
//  ReusableTableViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 06/05/16.
//
//

import UIKit

class ReusableTableViewController<T, C:UITableViewCell>: UITableViewController {
    internal(set) var objects: [T]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.objects = [T]()
        load()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier(forIndexPath: indexPath), forIndexPath: indexPath) as! C
        let object = self.objectAtIndexPath(indexPath)
        self.inflateCell(cell, forObject: object, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return objects.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func numberOfObjectsForLoad() -> Int {
        return Config.TableView.listLoadLimit
    }

    
    func objectAtIndexPath(indexPath: NSIndexPath) -> T {
        return objects[indexPath.row]
    }
    
    func cellIdentifier(forIndexPath indexPath: NSIndexPath) -> String {
        return Config.TableView.CellIdentifiers.CharacterCell
    }
    
    func inflateCell(cell: C, forObject object: T, atIndexPath indexPath: NSIndexPath) {
       
    }
    
    func dataWithLimit(limit: Int, offset: Int, completionHandler: (objects:NSArray?) -> Void) {

    }

    func load() {
        
        let limit = self.numberOfObjectsForLoad()
        let offset = 0
        
        self.handleFetching(limit, offset: offset, before: {
            (Void) in
            
            //hide internet connection problem or no content messages
       //     self.tableView.hideText()
        //    self.tableView.showActivityIndicator(self.activityIndicatorPosition())
            
            }, after: {
                (objects: [T]?) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    //load table with new objects
                    if(objects != nil){
                        self.objects = objects!
                        self.tableView.reloadData()
                    }
                   // self.tableView.hideActivityIndicator()
                })
                
                
               
        })
    }
    
    private func handleFetching(limit: Int, offset: Int, before: (Void) -> Void, after: ([T]?) -> Void) {
        before()
        self.dataWithLimit(limit, offset: offset, completionHandler: {
            (objects: NSArray?) -> Void in
            
            //enable load more
            //self.newDataLoadingEnabled = true
            
            if objects != nil {
                var newObjects = [T]()
                for object in objects! {
                    newObjects.append(object as! T)
                }
                after(newObjects)
            }else{
                after(nil)
            }
            
        })
        
    }
    
}


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
                            if image != nil {
                                imageView.image = image
                            } else {
                                imageView.image = self.placeholderForImageView(imageView, andObject: object, indexPath: indexPath)
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



class CharactersTableViewController: ImageReusableTableViewController<Character, UITableViewCell> {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func dataWithLimit(limit: Int, offset: Int, completionHandler: (objects: NSArray?) -> Void) {
        
        MarvelRequest.getCharachterIndex { (ok:Bool, objects: [Character]?, error: NSError?) in
            completionHandler(objects: objects)
        }
    }
    
    override func cellIdentifier(forIndexPath indexPath: NSIndexPath) -> String {
        return Config.TableView.CellIdentifiers.CharacterCell
    }
    
    override func inflateCell(cell: UITableViewCell, forObject object: Character, atIndexPath indexPath: NSIndexPath) {
        
        if(cell.backgroundView == nil){
            let imageView = UIImageView()
            imageView.contentMode = UIViewContentMode.Center
            cell.backgroundView = imageView
        }
        
        super.inflateCell(cell, forObject: object, atIndexPath: indexPath)
        cell.textLabel?.text = object.name
        cell.backgroundColor = UIColor.clearColor()
    }
    
    
    override func getImageHashForObject(object: Character, atIndexPath indexPath: NSIndexPath)->Int{
        return object.hashValue
    }
    
    
    override func imageViewsForCell(cell: UITableViewCell, andObject object: Character, indexPath: NSIndexPath) -> [UIImageView] {
        return [cell.backgroundView as! UIImageView]
    }
    
    override func image(imageView: UIImageView, object: Character, indexPath: NSIndexPath, completionHandler: (image:UIImage?) -> Void) -> UIImage? {
        
        //try to download image
        if let localImage = MarvelRequest.getCharacterThumbnail(object, saveLocally: true, completionHandler: {
            (image: UIImage?) -> Void in
            completionHandler(image: image)
        }) {
            return localImage
        }
        
        return super.image(imageView, object: object, indexPath: indexPath, completionHandler: completionHandler)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    
}