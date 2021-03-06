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
    func changeSearchBarVisibility(visible: Bool)
}

class CharactersSearchResultsController: BaseContainerViewController {

    var delegate:CharactersSearchResultsControllerDelegate?
    
    var searchText: String = ""
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBarHidden = true
        if let charactersTableViewController = self.contentViewController as? CharactersTableViewController{
            charactersTableViewController.delegateDataSource = self
            charactersTableViewController.imageDelegate = self
            charactersTableViewController.delegate = self
        }
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate?.changeSearchBarVisibility(true)
    }
    
}


extension CharactersSearchResultsController: ReusableTableViewControllerDataSourceDelegate{
    func dataWithLimit(limit: Int, offset: Int, completionHandler: (objects: NSArray?) -> Void) {
        MarvelApiManager.request.getCharachterSearch(self.searchText, limit: limit, offset: offset) { (ok, objects, error) in
            completionHandler(objects: objects)
        }
    }
    
    func setupTableView(tableView: UITableView) {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
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
           self.delegate?.changeSearchBarVisibility(false)
           self.navigationController?.pushViewController(UIStoryboard.detailsTableViewController(character), animated: true)
        }
    }
}


