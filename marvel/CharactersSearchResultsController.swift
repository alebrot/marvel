//
//  CharactersSearchResultsController.swift
//  marvel
//
//  Created by khlebtsov alexey on 11/05/16.
//
//

import UIKit

class CharactersSearchResultsController: BaseContainerViewController {

    override func viewDidLoad() {
        
        if let charactersTableViewController = self.contentViewController as? CharactersTableViewController{
            charactersTableViewController.delegate = self
        }
        
        super.viewDidLoad()
       // self.contentViewController = UIStoryboard.charactersTableViewController()
        
   
    }
    
    
}

extension CharactersSearchResultsController: ReusableTableViewControllerDelegate{
    func dataWithLimit(limit: Int, offset: Int, completionHandler: (objects: NSArray?) -> Void) {

        MarvelRequest.getCharachterIndex(limit, offset: offset) { (ok, objects, error) in
            completionHandler(objects: objects)
        }
    }
}


extension CharactersSearchResultsController: UISearchBarDelegate{
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
          print(searchText)
    }

}





