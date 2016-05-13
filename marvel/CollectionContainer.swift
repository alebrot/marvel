//
//  CollectionContainer.swift
//  marvel
//
//  Created by khlebtsov alexey on 13/05/16.
//
//

import UIKit

class CollectionContainer: BaseContainerViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pagerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pictureCollectionViewController = self.contentViewController as? PictureCollectionViewController{
            pictureCollectionViewController.delegate = self
        }
        
        
    }
}


extension CollectionContainer: PictureCollectionViewControllerDelegate{
    func currentPageIndex(page: Int, pagesCount: Int){
        self.pagerLabel.text = "\(page)/\(pagesCount)"
    }
    func currentPageTitle(title: String){
        self.nameLabel.text = title
    }
}

