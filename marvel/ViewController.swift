//
//  ViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 04/05/16.
//
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        MarvelRequest.getCharachterIndex { (ok:Bool, objects: [Character]?, error: NSError?) in
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

