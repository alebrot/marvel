//
//  CharactersIndexViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 11/05/16.
//
//

import UIKit

class CharactersIndexViewController: BaseContainerViewController {
   
    var searchController: UISearchController!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false

    }
    
    override func viewDidLoad() {

        
        if let charactersTableViewController = self.contentViewController as? CharactersTableViewController{
            charactersTableViewController.delegateDataSource = self
            charactersTableViewController.delegate = self
        }
        
        let searchItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(CharactersIndexViewController.showSearch(_:)))
        self.navigationItem.rightBarButtonItem = searchItem
        
        
        let charactersSearchResultsController = UIStoryboard.charactersSearchResultsController()
        
        charactersSearchResultsController.delegate = self
        
        self.searchController = UISearchController(searchResultsController: charactersSearchResultsController)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = charactersSearchResultsController
        self.searchController.searchBar.barStyle = UIBarStyle.Black
        self.searchController.searchBar.tintColor = UINavigationBar.appearance().tintColor
        self.searchController.searchBar.translucent = false

        
        super.viewDidLoad()

    }
    
    func showSearch(sender: UIBarButtonItem) {
        self.presentViewController(self.searchController, animated: true, completion: nil)
    }
}


extension CharactersIndexViewController: ReusableTableViewControllerDataSourceDelegate{
    func dataWithLimit(limit: Int, offset: Int, completionHandler: (objects: NSArray?) -> Void) {
        
        MarvelRequest.getCharachterIndex(limit, offset: offset) { (ok, objects, error) in
            completionHandler(objects: objects)
        }
    }
}


extension CharactersIndexViewController: CharactersSearchResultsControllerDelegate{
    func didSelectCharacter(character: Character) {
        self.navigationController?.pushViewController(UIStoryboard.detailsTableViewController(character), animated: true)
    }
}

extension CharactersIndexViewController: ReusableTableViewControllerDelegate{
    func didSelectObject(object: AnyObject, atIndexPath indexPath: NSIndexPath) {
        if let character = object as? Character{
            self.navigationController?.pushViewController(UIStoryboard.detailsTableViewController(character), animated: true)
        }
    }
}