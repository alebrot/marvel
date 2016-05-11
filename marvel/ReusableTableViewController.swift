//
//  ReusableTableViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 06/05/16.
//
//

import UIKit

@objc protocol ReusableTableViewControllerDelegate {
    func dataWithLimit(limit: Int, offset: Int, completionHandler: (objects:NSArray?) -> Void)
}


class ReusableTableViewController<T, C:UITableViewCell>: UITableViewController {
    
    var delegate: ReusableTableViewControllerDelegate?

    
    private let loadMoreOffset: CGFloat = 42.0
    private var loadMoreIndicator: UIView!
    
    private var newDataLoadingEnabled: Bool!
    private var isFetching: Bool!
    private var previousScrollViewYOffset: CGFloat = 0
    private var threshold: CGFloat!
    private var pointNow: CGPoint = CGPointZero
    
    
    internal(set) var objects: [T]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.threshold = 40
        self.isFetching = false
        self.newDataLoadingEnabled = true
        
        //setup load more view
        let loadMoreIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadMoreIndicator.startAnimating()
        self.loadMoreIndicator = loadMoreIndicator
        
        //set up refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ReusableTableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
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
        self.delegate?.dataWithLimit(limit, offset: offset, completionHandler: completionHandler)
    }
    
    //internal callback
    func refresh() {
        
        let limit = self.numberOfObjectsForLoad()
        let offset = 0
        
        self.handleFetching(limit, offset: offset, before: {
            (Void) in
                self.refreshControl?.beginRefreshing()
            }, after: {
                (objects: [T]?) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    //load table with new objects
                    if(objects != nil){
                        self.loadData(objects!)
                    }
                    self.refreshControl?.endRefreshing()
                })
                
        })
        
    }
    
    func load() {
        let limit = self.numberOfObjectsForLoad()
        let offset = 0
        
        self.handleFetching(limit, offset: offset, before: {
            (Void) in
            
            }, after: {
                (objects: [T]?) in
                dispatch_async(dispatch_get_main_queue(), {

                    self.loadData(objects)
                    
                 })
        })
    }
    
    //call to update table with new objects (should be executed on main thread)
    func loadData(objects: [T]?) {

            if objects != nil {
                self.objects = objects!
            } else {
                self.objects = [T]()
            }
             self.tableView.reloadData()
    }
    
    private func scrollDelegateHelper(scrollView: UIScrollView) {
        let scrollSpeed = scrollView.contentOffset.y - previousScrollViewYOffset;
        previousScrollViewYOffset = scrollView.contentOffset.y;
        if abs(scrollSpeed) > threshold {
            if (scrollView.contentOffset.y < pointNow.y) {
                //down
                // self.scrollViewDidAccelerateUp(false)
                
            } else if (scrollView.contentOffset.y > pointNow.y) {
                // self.scrollViewDidAccelerateUp(true)
            }
            
        }
        
    }
    
    
    private func handleFetching(limit: Int, offset: Int, before: (Void) -> Void, after: ([T]?) -> Void) {
        before()
        self.dataWithLimit(limit, offset: offset, completionHandler: {
            (objects: NSArray?) -> Void in
            
            //enable load more
            self.newDataLoadingEnabled = true
            
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
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset;
    }
    
    override  func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (Int(scrollView.contentOffset.y + scrollView.frame.size.height + self.loadMoreOffset) >= Int(scrollView.contentSize.height + scrollView.contentInset.bottom)) {
            if (newDataLoadingEnabled == true && isFetching == false) {
                
                let limit = self.numberOfObjectsForLoad()
                
                let offset = self.objects.count
                
                self.handleFetching(limit, offset: offset, before: {
                    (Void) in
                        self.isFetching = true
                        self.tableView.tableFooterView = self.loadMoreIndicator
                        self.tableView.scrollRectToVisible(self.tableView.tableFooterView!.frame, animated: true)
                    }, after: {
                        (newObjects: [T]?) in
                        
                        
                        sleep(1)
                        
                        var indexPaths = [NSIndexPath]()
                        if newObjects != nil && newObjects!.count != 0 {
                            //append new objects to array of objects
                            for index in 0...(newObjects!.count-1){
                                let newObject = newObjects![index]
                                self.objects.append(newObject)
                                indexPaths.append(NSIndexPath(forRow: (self.objects.count-1), inSection: 0))
                            }
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            if newObjects != nil {
                                self.tableView.beginUpdates()
                                self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                                self.tableView.endUpdates()
                            }
                            
                            if newObjects == nil || newObjects!.count == 0 {
                                //disable fetching permanently
                                self.newDataLoadingEnabled = false
                            }
                            
                            //hide footer with loading view
                            self.tableView.tableFooterView = nil
                            self.isFetching = false
                            
                        })
                        
                        
                })
            }
        } else {
            self.scrollDelegateHelper(scrollView)
        }
        
    }
    
}