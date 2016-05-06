//
//  ApiRepository.swift
//  marvel
//
//  Created by khlebtsov alexey on 04/05/16.
//
//

import Foundation


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
        }
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
}