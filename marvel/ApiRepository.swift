//
//  ApiRepository.swift
//  marvel
//
//  Created by khlebtsov alexey on 04/05/16.
//
//

import Foundation
import UIKit

class ApiRepository {
    
    static let dictionarySingleNameKey = "data"
    static let dictionaryMultipleNameKey = "data"
    
    func getSingleObject<T>(request: NSURLRequest, mapperType: BaseMapper<T>.Type, completionHandler: (ok:Bool, object:T?, error:NSError?) -> Void) {
        NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            var object: T?
            var ok = false
            if let dictionary = data?.toDictionary() {
                if let dataDict = dictionary[ApiRepository.dictionarySingleNameKey] as? Dictionary<String, AnyObject> {
                    
                    object = mapperType.createObjectFrom(dataDict)
                    if(object != nil){
                        ok = true
                    }
                }
            }
            completionHandler(ok: ok, object: object, error: error)
        }.resume()
    }
    
    func getMultipleObjects<T>(request: NSURLRequest, mapperType: BaseMapper<T>.Type, completionHandler: (ok:Bool, objects:[T]?, error:NSError?) -> Void) {
        NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            var objects: [T]?
            var ok = false
            
            if let dictionary = data?.toDictionary(){
                if let dataDict = mapperType.getRoot(dictionary) as? NSArray {
                    objects = mapperType.createArrayFrom(dataDict)
                    ok = (objects != nil)
                }
            }
            
            completionHandler(ok: ok, objects: objects, error: error)
            }.resume()
    }
    
    
    func downloadImage(url: NSURL?, storageFilePaths: String, saveLocally: Bool = true, completionHandler: (image:UIImage?) -> Void){
        if(url != nil){
            let request = NSURLRequest(URL: url!)
            
            var image: UIImage?
            
            NSURLSession.sharedSession().downloadTaskWithRequest(request, completionHandler: {
                (url: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
                var data: NSData? = nil
                if error == nil && url != nil {
                    data = NSData(contentsOfURL: url!)
                    if (data != nil) {
                        if (saveLocally) {
                            //save user photo in the storage
                            Utilities.fileStorage.saveFile(data!, path: storageFilePaths)
                        }
                        //create image
                        image = UIImage(data: data!)
                        
                    }
                }
                completionHandler(image: image)
                
                
                
            }).resume()
            
            
        }
    }
    
    
}