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
    
    private let privateKey: String
    private let  publicKey: String
    private let baseUrl: String
    
    private static let apiKey = "apikey"
    private static let hashKey = "hash"
    private static let timestampKey = "ts"
    
    private static let limitKey = "limit"
    private static let offsetKey = "offset"
    
    private static let nameStartsWithKey = "nameStartsWith"
    
    init(baseUrl: String, privateKey: String, publicKey: String){
        self.baseUrl = baseUrl
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    func  getCharachterIndex(limit: Int, offset: Int, completionHandler: CompletionHandlerCharacters){
        var params = getDeafultParams()
        params[MarvelRequest.limitKey] = limit
        params[MarvelRequest.offsetKey] = offset

        if let url = NSURL(string:baseUrl+"characters")?.URLByAppendingQueryParams(params){
            let request =  NSURLRequest(URL: url)
            ApiRepository().getMultipleObjects(request, mapperType: CharacterMapper.self, completionHandler: completionHandler)
        }
        
    }
    
    func  getCharachterSearch(text: String, limit: Int, offset: Int, completionHandler: CompletionHandlerCharacters){
        var params = getDeafultParams()
        params[MarvelRequest.limitKey] = limit
        params[MarvelRequest.offsetKey] = offset
        params[MarvelRequest.nameStartsWithKey] = text
        
        if let url = NSURL(string:baseUrl+"characters")?.URLByAppendingQueryParams(params){
            let request =  NSURLRequest(URL: url)
            ApiRepository().getMultipleObjects(request, mapperType: CharacterMapper.self, completionHandler: completionHandler)
        }
        
    }

    func  getComic(url: NSURL, completionHandler: CompletionHandlerComics){
        let request =  NSURLRequest(URL: url.URLByAppendingQueryParams(getDeafultParams()))
        ApiRepository().getMultipleObjects(request, mapperType: ComicMapper.self, completionHandler: completionHandler)        
    }
    
    
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
    
    private func getDeafultParams() -> [String: AnyObject]{
        let ts = Int(NSDate().timeIntervalSince1970)
        let hash = "\(ts)\(privateKey)\(publicKey)".md5()
        let params: [String: AnyObject] = [MarvelRequest.apiKey: publicKey, MarvelRequest.hashKey: hash, MarvelRequest.timestampKey:ts]
        return params
    }
    
    private func getMultipleObjects<T>(request: NSURLRequest, mapperType: BaseMapper<T>.Type, completionHandler: (ok:Bool, objects:[T]?, error:NSError?) -> Void) {
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
    
    private func downloadImage(url: NSURL?, storageFilePaths: String, saveLocally: Bool = true, completionHandler: (image:UIImage?) -> Void){
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
