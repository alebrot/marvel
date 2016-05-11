//
//  CharactersSearchResultsController.swift
//  marvel
//
//  Created by khlebtsov alexey on 11/05/16.
//
//

import UIKit

class CharactersSearchResultsController: BaseContainerViewController {

    
    var searchText: String = ""
    
    override func viewDidLoad() {
        
        if let charactersTableViewController = self.contentViewController as? CharactersTableViewController{
            charactersTableViewController.delegate = self
            
            charactersTableViewController.tableView.contentInset.top = 64//44 + UIApplication.sharedApplication().statusBarFrame.size.height

        }
        
        super.viewDidLoad()
        
        
        
       // self.contentViewController = UIStoryboard.charactersTableViewController()
//         self.edgesForExtendedLayout = UIRectEdge.None;
//        self.automaticallyAdjustsScrollViewInsets = false
        
        
    }
    
    
}

extension CharactersSearchResultsController: ReusableTableViewControllerDelegate{
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
//            MarvelRequest.getCharachterSearch(self.searchText, limit: charactersTableViewController.numberOfObjectsForLoad(), offset: 0) { (ok, objects, error) in
//                charactersTableViewController.loadData(objects)
//                print(objects)
//                
//            }
        }
        
        
 
        
          print(searchText)
    }

}





