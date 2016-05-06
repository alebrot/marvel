//
//  BaseMapper.swift
//  marvel
//
//  Created by khlebtsov alexey on 04/05/16.
//
//

import Foundation

protocol Mapper {
    associatedtype T
    
    static func createObjectFrom(dictionary: Dictionary<String, AnyObject> ) -> T?
    static func createArrayFrom(dictionaryArray: NSArray ) -> [T]?
    static func createDictionaryFrom(object: T) -> Dictionary<String, AnyObject>
}

class BaseMapper<T>: Mapper {
    
    class func getRoot(dictionary: Dictionary<String, AnyObject> ) -> AnyObject?{
        return nil
    }
    
    class func createObjectFrom(dictionary: Dictionary<String, AnyObject> ) -> T?{
        return nil
    }
    
    class func createArrayFrom(dictionaryArray: NSArray ) -> [T]?{
        var resultArray = [T]()
        
        for raw in dictionaryArray {
            var object : T?
            if let dict = raw as? Dictionary<String, AnyObject> {
                object = createObjectFrom(dict)
            }
            
            if object != nil {
                resultArray.append(object!)
            }
            else {
                return nil
            }
        }
        
        return resultArray
    }
    
    class func createDictionaryFrom(object: T) -> Dictionary<String, AnyObject>{
        return [:]
    }
    
    class func createDictionaryArrayFrom(objects: [T]) -> [Dictionary<String, AnyObject>]{
        var dictionaryArray = [Dictionary<String, AnyObject>]()
        for object in objects{
            dictionaryArray.append(createDictionaryFrom(object))
        }
        return dictionaryArray
    }
    
}