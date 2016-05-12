//
//  ContentViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 12/05/16.
//
//

import UIKit

class ContentViewController: UIViewController {
    var item: Item?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if( item != nil ){
            let url = item!.resourceURI
            label.text = item!.name
            
            MarvelRequest.getComic(url, completionHandler: { (ok: Bool, objects: [Comic]?, error: NSError?) in
                if let comic = objects?.first{
                    ApiRepository().downloadImage(comic.thumbnailURI, storageFilePaths: Config.StorageFilePaths.resourceComicsPath(String(comic.hashValue)), completionHandler: { (image) in
                        dispatch_async(dispatch_get_main_queue(), {
                            self.imageView.image = image        
                        })
                    
                    })
                }
            })
            
        }
        
    }
}
