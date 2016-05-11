//
//  AppDelegate.swift
//  marvel
//
//  Created by khlebtsov alexey on 04/05/16.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
         return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}



public extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    internal class func charactersTableViewController() -> CharactersTableViewController {
        //When the storyboarding class is loaded at runtime, the [.*]Class is referenced using a string.
        //The linker doesn't analyze code functionality, so it doesn't know that the class is used. Since no other source files references that class, the linker optimizes it out of existence when making the executable.
        CharactersTableViewController.hash()
        return mainStoryboard().instantiateViewControllerWithIdentifier("CharactersTableViewController") as! CharactersTableViewController
        
    }
    
    internal class func charactersSearchResultsController() -> CharactersSearchResultsController {

        
        // frame: CGRect(x: ctvc.view.frame.origin.x, y: 40, width: ctvc.view.frame.size.width, height: ctvc.view.frame.size.height)
//        
//        let ctvc =  self.charactersTableViewController()
//        
//        
//        let vc = CharactersSearchResultsController(viewController: ctvc)
//        return vc
        
        
        let continerViewController = mainStoryboard().instantiateViewControllerWithIdentifier("CharactersSearchResultsController") as! CharactersSearchResultsController
        continerViewController.contentViewController = self.charactersTableViewController()
        return continerViewController

    }
    
    internal class func charactersIndexViewController() -> CharactersIndexViewController {
                
        let containerViewController = CharactersIndexViewController(viewController: self.charactersTableViewController())
        return containerViewController
        
    }
    
    
    
}