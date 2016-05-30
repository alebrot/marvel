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
        
        UINavigationBar.appearance().tintColor = UIColor.redColor()
        UINavigationBar.appearance().translucent = false
   
        let navigationViewController = UINavigationController(rootViewController: UIStoryboard.charactersIndexViewController())
        navigationViewController.navigationBar.barStyle = .Black
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController =  navigationViewController
        window?.makeKeyAndVisible()
        
        let splashViewController = UIStoryboard.viewController()
        
        window?.addSubview(splashViewController.view)
        let delay = (Int64(NSEC_PER_SEC) * 3) //3 sec delay
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay), dispatch_get_main_queue(), { () -> Void in
            splashViewController.view.removeFromSuperview()
        })
                
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
        Utilities.fileStorage.removeDirectoryContent(FileStorageUtilities.storageBasePath)
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
    
    
    internal class func searchCharactersViewController() -> CharactersTableViewController {
        CharactersTableViewController.hash()
        return mainStoryboard().instantiateViewControllerWithIdentifier("SearchCharactersViewController") as! CharactersTableViewController
    }
    
    internal class func charactersSearchResultsController() -> CharactersSearchResultsController {
        return CharactersSearchResultsController(viewController: self.searchCharactersViewController())
    }
    
    
    
    internal class func charactersIndexViewController() -> CharactersIndexViewController {
        return CharactersIndexViewController(viewController: self.charactersTableViewController())
    }
    
    internal class func pictureCollectionViewController(character: Character) -> PictureCollectionViewController {
        let vc = mainStoryboard().instantiateViewControllerWithIdentifier("PictureCollectionViewController") as! PictureCollectionViewController
        vc.character = character
        return vc
        
    }
    
    internal class func collectionContainer(character: Character) -> CollectionContainer {
        let vc = mainStoryboard().instantiateViewControllerWithIdentifier("CollectionContainer") as! CollectionContainer
        let pvc = self.pictureCollectionViewController(character)
        pvc.enableCloseButton = true
        vc.contentViewController = pvc
        return vc
        
    }
    
    internal class func detailsTableViewController(character: Character) -> DetailsTableViewController {
        let vc = mainStoryboard().instantiateViewControllerWithIdentifier("DetailsTableViewController") as! DetailsTableViewController
        vc.character = character
        return vc
        
    }
    
    internal class func viewController() -> SplashViewController {
        let vc = mainStoryboard().instantiateViewControllerWithIdentifier("SplashViewController") as! SplashViewController
        return vc
    }    
    
}