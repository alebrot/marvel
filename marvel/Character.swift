//
//  Character.swift
//  marvel
//
//  Created by khlebtsov alexey on 05/05/16.
//
//

import Foundation



class Character: NSObject {
    
    private static let hashPrefix = "Character"

    
    var id: Int
    var name: String
    var desc: String
    var modified: NSDate
    var resourceURI: NSURL
    var thumbnailURI: NSURL

    
    override var hashValue: Int {
        return "\(Character.hashPrefix)\(id)\(name)".hashValue
    }
    
    init(id: Int, name: String, description: String, modified: NSDate, resourceURI: NSURL, thumbnailURI: NSURL){
        self.id = id
        self.name = name
        self.desc = description
        self.modified = modified
        self.resourceURI = resourceURI
        self.thumbnailURI = thumbnailURI
    }
}

class CharacterMapper: BaseMapper<Character>{
    
    private static let dataKey = "data"
    private static let resultsKey = "results"
    
    private static let idKey = "id"
    private static let nameKey = "name"
    private static let descriptionKey = "description"
    private static let modifiedKey = "modified"
    private static let resourceURIKey = "resourceURI"
    
    private static let thumbnailKey = "thumbnail"
    private static let pathKey = "path"
    private static let extensionKey = "extension"
    
    override class func createObjectFrom(dictionary: Dictionary<String, AnyObject> ) -> Character?{
        
        if let id = dictionary[idKey] as? Int{
            if let name =  dictionary[ nameKey ] as? String{
                if let description =  dictionary[ descriptionKey ] as? String{
                    
                    let modifiedString = dictionary[ modifiedKey ] as? String
                    let dateFormatter = Utilities.typeConversion.getDateFormatter(TypeConversionUtilities.ISO8601)
                    if let modified = Utilities.typeConversion.getNSDateFromString(modifiedString, dateFormatter: dateFormatter){
                        
                        if let resourceURI = NSURL.fromString(dictionary[resourceURIKey] as? String ){
                            
                            if let thumbnailDict = dictionary[thumbnailKey] as? Dictionary<String, AnyObject>{
                                if let thumbnailPath = thumbnailDict[pathKey] as? String{
                                    if let ext = thumbnailDict[extensionKey] as? String{
                                        if let thumbnailURI =  NSURL.fromString(thumbnailPath){
                                            let thumbnailURIWithExtension = thumbnailURI.URLByAppendingPathExtension(ext)
                                            
                                            return Character(id: id, name: name, description: description, modified: modified, resourceURI: resourceURI, thumbnailURI: thumbnailURIWithExtension)

                                        }
                                    }
                                }
                            }
                            
                            
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
