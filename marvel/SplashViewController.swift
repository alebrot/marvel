//
//  ViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 04/05/16.
//
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.Autoreverse, .Repeat], animations: {
            var frame = self.imageView.frame;
            frame.origin.y = frame.origin.y - 8;
            self.imageView.frame = frame;
            }, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

