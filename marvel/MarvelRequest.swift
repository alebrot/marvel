//
//  MarvelRequest.swift
//  marvel
//
//  Created by khlebtsov alexey on 05/05/16.
//
//

import Foundation
import UIKit

class MarvelRequest{
    
    typealias CompletionHandlerCharacters = (ok: Bool, objects: [Character]?, error: NSError?) -> Void
    typealias CompletionHandlerComics = (ok: Bool, objects: [Comic]?, error: NSError?) -> Void

    
    private static let privateKey =  Config.Keys.marvelPrivate
    private static let  publicKey =  Config.Keys.marvelPublic
    private static let baseUrl = Config.baseUrl
    
    private static let apiKey = "apikey"
    private static let hashKey = "hash"
    private static let timestampKey = "ts"
    
    private static let limitKey = "limit"
    private static let offsetKey = "offset"
    
    private static let nameStartsWithKey = "nameStartsWith"
  

    static func  getCharachterIndex(limit: Int, offset: Int, completionHandler: CompletionHandlerCharacters){
        
        var params = getDeafultParams()
        params[MarvelRequest.limitKey] = limit
        params[MarvelRequest.offsetKey] = offset

        
        if let url = NSURL(string:MarvelRequest.baseUrl+"characters")?.URLByAppendingQueryParams(params){
            let request =  NSURLRequest(URL: url)
            ApiRepository().getMultipleObjects(request, mapperType: CharacterMapper.self, completionHandler: completionHandler)
        }
        
    }
    
    static func  getCharachterSearch(text: String, limit: Int, offset: Int, completionHandler: CompletionHandlerCharacters){
        var params = getDeafultParams()
        params[MarvelRequest.limitKey] = limit
        params[MarvelRequest.offsetKey] = offset
        params[MarvelRequest.nameStartsWithKey] = text
        
        if let url = NSURL(string:MarvelRequest.baseUrl+"characters")?.URLByAppendingQueryParams(params){
            let request =  NSURLRequest(URL: url)
            ApiRepository().getMultipleObjects(request, mapperType: CharacterMapper.self, completionHandler: completionHandler)
        }
        
    }
    
    
    static func  getComic(url: NSURL, completionHandler: CompletionHandlerComics){
        let request =  NSURLRequest(URL: url.URLByAppendingQueryParams(getDeafultParams()))
        ApiRepository().getMultipleObjects(request, mapperType: ComicMapper.self, completionHandler: completionHandler)        
    }
    
    
//    static func  getResource(url: NSURL){
//        let params = getDeafultParams()
//
//        let request =  NSURLRequest(URL: url.URLByAppendingQueryParams(params))
//        ApiRepository().getSingleObject(request, mapperType: ResourceMapper.self) { (ok, object, error) in
//            
//        }
//        
//    }
    
    
    static func getCharacterThumbnail(character: Character, saveLocally: Bool = true, completionHandler: (image:UIImage?) -> Void) -> UIImage? {
        
        let path = Config.StorageFilePaths.characterThumbnailPath(String(character.hashValue))
        let url = character.thumbnailURI
        
        if let image = ImageUtilities.getImage(path){ //get user photo from the storage if present
            return image
        }else{   //download user photo
            ApiRepository().downloadImage(url, storageFilePaths: path, saveLocally: saveLocally, completionHandler: completionHandler)
            return nil
        }
        
    }
    
    
    private static func getDeafultParams() -> [String: AnyObject]{
        let ts = Int(NSDate().timeIntervalSince1970)
        let hash = "\(ts)\(MarvelRequest.privateKey)\(MarvelRequest.publicKey)".md5()
        let params: [String: AnyObject] = [MarvelRequest.apiKey: MarvelRequest.publicKey, MarvelRequest.hashKey: hash, MarvelRequest.timestampKey:ts]
        return params
    }
    

    
    
}
