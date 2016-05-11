//
//  BaseContainerViewController.swift
//  marvel
//
//  Created by khlebtsov alexey on 11/05/16.
//
//

import UIKit

class BaseContainerViewController: UIViewController {
    @IBOutlet weak var containerView: UIView?
    
    var contentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        if let vc = contentViewController {
            
            //setup container
            self.addChildViewController(vc)
            
            if let containerView = self.containerView {
                vc.view.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)
                containerView.addSubview(vc.view)
            } else {
                vc.view.frame = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
                view.addSubview(vc.view)
            }
            
            vc.didMoveToParentViewController(self)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    convenience init(viewController: UIViewController){
        self.init(nibName: nil, bundle: nil)
        self.contentViewController = viewController
    }
    
    convenience init(viewController: UIViewController, containerView: UIView){
        self.init(nibName: nil, bundle: nil)
        self.contentViewController = viewController
        self.containerView = containerView
    }

//    @IBOutlet weak var containerView: UIView?
//    
//    var contentViewController: UIViewController?
//    
//    private var contentFrame: CGRect?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//                
//        if let vc = contentViewController {
//            
//            //setup container
//            self.addChildViewController(vc)
//            
//            if let containerView = self.containerView {
//                vc.view.frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y, containerView.frame.size.width, containerView.frame.size.height)
//                containerView.addSubview(vc.view)
//            } else {
//                if let frame = self.contentFrame{
//                    vc.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
//                }else{
//                    vc.view.frame = CGRectMake(vc.view.frame.origin.x, vc.view.frame.origin.y, vc.view.frame.size.width, vc.view.frame.size.height);
//                }
//                view.addSubview(vc.view)
//            }
//            
//            vc.didMoveToParentViewController(self)
//        }
//        
//        // Do any additional setup after loading the view.
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    convenience init(viewController: UIViewController){
//        self.init(nibName: nil, bundle: nil)
//        self.contentViewController = viewController
//    }
//    
//    convenience init(viewController: UIViewController, frame: CGRect){
//        self.init(nibName: nil, bundle: nil)
//        self.contentViewController = viewController
//        self.contentFrame = frame
//    }
//    
//    convenience init(viewController: UIViewController, containerView: UIView){
//        self.init(nibName: nil, bundle: nil)
//        self.contentViewController = viewController
//        self.containerView = containerView
//    }

}
