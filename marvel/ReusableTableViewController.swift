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


class CharactersTableViewController: ReusableTableViewController<Character, UITableViewCell> {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.textLabel?.text = object.name
    }
    
}