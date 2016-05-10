//
//  CharactersTableViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 10/05/16.
//
//

import UIKit

class CharactersTableViewController: ImageReusableTableViewController<Character, UITableViewCell> {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func dataWithLimit(limit: Int, offset: Int, completionHandler: (objects: NSArray?) -> Void) {
        MarvelRequest.getCharachterIndex(limit, offset: offset) { (ok, objects, error) in
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
            cell.backgroundColor = UIColor.clearColor()
        }
        
        super.inflateCell(cell, forObject: object, atIndexPath: indexPath)
        cell.textLabel?.text = object.name
        
    }
    
    override func getImageHashForObject(object: Character, atIndexPath indexPath: NSIndexPath)->Int{
        return object.hashValue
    }
    
    override func imageViewsForCell(cell: UITableViewCell, andObject object: Character, indexPath: NSIndexPath) -> [UIImageView] {
        return [cell.backgroundView as! UIImageView]
    }
    
    override func image(imageView: UIImageView, object: Character, indexPath: NSIndexPath, completionHandler: (image:UIImage?) -> Void) -> UIImage? {
        
        //try to download image
        if let localImage = MarvelRequest.getCharacterThumbnail(object, saveLocally: true, completionHandler: completionHandler) {
            return localImage
        }
        
        return super.image(imageView, object: object, indexPath: indexPath, completionHandler: completionHandler)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
}