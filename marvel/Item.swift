//
//  Item.swift
//  marvel
//
//  Created by khlebtsov alexey on 12/05/16.
//
//

import Foundation

struct Item{
    var name: String
    var resourceURI: NSURL
}

func ==(a: Item, b: Item) -> Bool {
    return a.hashValue == b.hashValue
}
extension Item: Hashable{
    
    private static let hashPrefix = "Item"
    var hashValue: Int {
        return "\(Item.hashPrefix)\(name.hashValue)".hashValue
    }
}

class ItemMapper: BaseMapper<Item>{
    
    private static let nameKey = "name"
    private static let resourceURIKey = "resourceURI"
    
    
    override class func createObjectFrom(dictionary: Dictionary<String, AnyObject> ) -> Item?{
        
        if let name =  dictionary[ nameKey ] as? String{
            
            if let resourceURI =  NSURL.fromString(dictionary[resourceURIKey] as? String){
                return Item(name: name, resourceURI: resourceURI)
            }
            
        }
        
        
        return super.createObjectFrom(dictionary)
    }
}
