//
//  DetailsTableViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 13/05/16.
//
//

import UIKit

class DetailsTableViewController: UITableViewController {
    
    var character: Character?
    

    @IBOutlet weak var headerImageView: UIImageView!
        {
        didSet {
            if self.character != nil{
                
                if let image = MarvelRequest.getCharacterThumbnail(self.character!, completionHandler: { (image) in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.headerImageView.image = image
                    })
                }){
                    
                    self.headerImageView.image = image
                }
                
                // st up back button
                let backButton = UIButton(frame: CGRectMake(0, 20, 50, 50))
                backButton.setBackgroundImage(UIImage(named: "ImageBack"), forState: UIControlState.Normal)
                backButton.addTarget(self, action: #selector(DetailsTableViewController.handleBackButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.headerImageView.addSubview(backButton)
                self.headerImageView.userInteractionEnabled = true
                
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!{
        didSet {
            if self.character != nil{
                nameLabel.text = self.character!.name
            }
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet {
            if self.character != nil{
                descriptionLabel.text = self.character!.desc
                
            }
        }
    }
    
    @IBOutlet weak var comicsContainer: UIView!
        {
        didSet {
            
            if self.character != nil{
                let vc = UIStoryboard.pictureCollectionViewController(self.character!)
                
                self.addChildViewController(vc)
                
                vc.view.frame = CGRectMake(0, 0, comicsContainer.frame.size.width, comicsContainer.frame.size.height)
                comicsContainer.addSubview(vc.view)
                vc.didMoveToParentViewController(self)
                vc.collectionView!.delegate = self
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        let panGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(DetailsTableViewController.handleBackSwipe(_:)))
        panGestureRecognizer.edges = UIRectEdge.Left
        tableView.addGestureRecognizer(panGestureRecognizer)
        //panGestureRecognizer.delegate = self
        
    }
    
    func handleBackButton(recognizer: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func handleBackSwipe(recognizer: UIScreenEdgePanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            if(gestureIsDraggingFromLeftToRight){
                self.navigationController?.popViewControllerAnimated(true)
            }
            break
        default:
            break
        }
    }
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView{
            header.textLabel?.textColor = UIColor.redColor()
        }
    }
}

extension DetailsTableViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: comicsContainer.frame.size.width/4, height: comicsContainer.frame.size.height-20)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.presentViewController(UIStoryboard.collectionContainer(self.character!), animated: true, completion: nil)
    }
}