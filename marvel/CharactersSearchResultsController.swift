//
//  CharactersSearchResultsController.swift
//  marvel
//
//  Created by khlebtsov alexey on 11/05/16.
//
//

import UIKit


protocol CharactersSearchResultsControllerDelegate{
    func didSelectCharacter(character: Character)
}

class CharactersSearchResultsController: BaseContainerViewController {

    
    var delegate:CharactersSearchResultsControllerDelegate?
    
    var searchText: String = ""
    
    override func viewDidLoad() {
        
        if let charactersTableViewController = self.contentViewController as? CharactersTableViewController{
            charactersTableViewController.delegateDataSource = self
            charactersTableViewController.imageDelegate = self
            charactersTableViewController.delegate = self
            charactersTableViewController.tableView.contentInset.top = 44 + UIApplication.sharedApplication().statusBarFrame.size.height
        }
        super.viewDidLoad()
    }
    
    
}

extension CharactersSearchResultsController: ReusableTableViewControllerDataSourceDelegate{
    func dataWithLimit(limit: Int, offset: Int, completionHandler: (objects: NSArray?) -> Void) {

        MarvelRequest.getCharachterSearch(self.searchText, limit: limit, offset: offset) { (ok, objects, error) in
            completionHandler(objects: objects)
        }
    }
}


extension CharactersSearchResultsController: UISearchBarDelegate{
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        if let charactersTableViewController = self.contentViewController as? CharactersTableViewController{
            charactersTableViewController.load()
        }
    }

}

extension CharactersSearchResultsController: ImageReusableTableViewControllerDelegate{
    func imageViewsForCell(cell: UITableViewCell, andObject object: AnyObject, indexPath: NSIndexPath) -> [UIImageView] {
        if let characteCell = cell as? CharacterCell{
            if let imageView = characteCell.photoImageView{
                return [imageView]
            }
        }
        return []
    }
}

extension CharactersSearchResultsController: ReusableTableViewControllerDelegate{
    func didSelectObject(object: AnyObject, atIndexPath indexPath: NSIndexPath) {
        if let character = object as? Character{
            self.dismissViewControllerAnimated(true, completion: { 
                self.delegate?.didSelectCharacter(character)
            })
        }
    }
}




