//
//  Comic.swift
//  marvel
//
//  Created by khlebtsov alexey on 12/05/16.
//
//

import Foundation

struct Comic{
    var id: Int
    var thumbnailURI: NSURL
}
func ==(a: Comic, b: Comic) -> Bool {
    return a.hashValue == b.hashValue
}
extension Comic: Hashable{
    
    private static let hashPrefix = "Comic"
    var hashValue: Int {
        return "\(Comic.hashPrefix)\(id)".hashValue
    }
}
class ComicMapper: BaseMapper<Comic>{
    
    private static let dataKey = "data"
    private static let resultsKey = "results"
    private static let idKey = "id"
    private static let thumbnailKey = "thumbnail"
    private static let pathKey = "path"
    private static let extensionKey = "extension"
    
    override class func createObjectFrom(dictionary: Dictionary<String, AnyObject> ) -> Comic?{
        
        if let id = dictionary[idKey] as? Int{
            if let thumbnailDict = dictionary[thumbnailKey] as? Dictionary<String, AnyObject>{
                if let thumbnailPath = thumbnailDict[pathKey] as? String{
                    if let ext = thumbnailDict[extensionKey] as? String{
                        if let thumbnailURI =  NSURL.fromString(thumbnailPath){
                            let thumbnailURIWithExtension = thumbnailURI.URLByAppendingPathExtension(ext)
                            return Comic(id: id, thumbnailURI: thumbnailURIWithExtension)
                        }
                    }
                }
            }
        }
        
        return super.createObjectFrom(dictionary)
    }
    
    override class func getRoot(dictionary: Dictionary<String, AnyObject> ) -> AnyObject?{
        if let dataDict = dictionary[dataKey]  as? Dictionary<String, AnyObject>{
            if let arrayDict = dataDict[resultsKey] as? NSArray {
                return arrayDict
            }
        }
        return super.getRoot(dictionary)
    }
}
