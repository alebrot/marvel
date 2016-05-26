//
//  CharactersTableViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 10/05/16.
//
//

import UIKit

class CharactersTableViewController: ImageReusableTableViewController<Character, CharacterCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func cellIdentifier(forIndexPath indexPath: NSIndexPath) -> String {
        return Config.TableView.CellIdentifiers.CharacterCell
    }
    
    override func inflateCell(cell: CharacterCell, forObject object: Character, atIndexPath indexPath: NSIndexPath) {
        
        if(cell.backgroundView == nil){
            let imageView = UIImageView()
            imageView.contentMode = UIViewContentMode.Center
            cell.backgroundView = imageView
            cell.backgroundColor = UIColor.clearColor()
        }
        
        super.inflateCell(cell, forObject: object, atIndexPath: indexPath)
        cell.nameLabel.text = object.name
        
    }
    
    override func getImageHashForObject(object: Character, atIndexPath indexPath: NSIndexPath)->Int{
        return object.hashValue
    }
    
    override func imageViewsForCell(cell: UITableViewCell, andObject object: Character, indexPath: NSIndexPath) -> [UIImageView] {
        if let imageViews = imageDelegate?.imageViewsForCell(cell, andObject: object, indexPath: indexPath){
            return imageViews
        }
        return [cell.backgroundView as! UIImageView]
    }
    
    override func image(imageView: UIImageView, object: Character, indexPath: NSIndexPath, completionHandler: (image:UIImage?) -> Void) -> UIImage? {
        
        //try to download image
        if let localImage = MarvelRequest.getCharacterThumbnail(object, saveLocally: true, completionHandler: completionHandler) {
            return localImage
        }
        
        return super.image(imageView, object: object, indexPath: indexPath, completionHandler: completionHandler)
    }
    
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
//        //let caracter = self.objects[indexPath.row]
//        //self.navigationController?.pushViewController(UIStoryboard.detailsTableViewController(caracter), animated: true)
//    }

    
}