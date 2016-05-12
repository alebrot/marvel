//
//  Resource.swift
//  marvel
//
//  Created by khlebtsov alexey on 12/05/16.
//
//

import Foundation

struct Resource{
    var available: Int
    var returned: Int
    var collectionURI: NSURL
    var items: [Item]
    
    
}

class ResourceMapper: BaseMapper<Resource>{
    
    private static let returnedKey = "returned"
    private static let availableKey = "available"
    private static let collectionURIKey = "collectionURI"
    private static let itemsKey = "items"
    
    override class func createObjectFrom(dictionary: Dictionary<String, AnyObject> ) -> Resource?{
        
        if let available = dictionary[availableKey] as? Int{
            if let returned =  dictionary[ returnedKey ] as? Int{
                if let collectionURI =  NSURL.fromString(collectionURIKey){
                    if let itemsDictionaryArray = dictionary[itemsKey] as? NSArray{
                        var items = [Item]()
                        for raw in itemsDictionaryArray{
                            if let itemDict = raw as? Dictionary<String, AnyObject>{
                                if let item = ItemMapper.createObjectFrom(itemDict){
                                    items.append(item)
                                }
                            }
                        }
                        return Resource(available: available, returned: returned, collectionURI: collectionURI, items: items)
                    }
                }
            }
        }
        
        return super.createObjectFrom(dictionary)
    }
}
