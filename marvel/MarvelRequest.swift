//
//  MarvelRequest.swift
//  marvel
//
//  Created by khlebtsov alexey on 05/05/16.
//
//

import Foundation

class MarvelRequest{
    
    typealias CompletionHandlerCharacters = (ok: Bool, objects: [Character]?, error: NSError?) -> Void
    
    private static let privateKey =  Config.Keys.marvelPrivate
    private static let  publicKey =  Config.Keys.marvelPublic
    private static let baseUrl = Config.baseUrl
    
    private static let apiKey = "apikey"
    private static let hashKey = "hash"
    private static let timestampKey = "ts"
    
    
    static func  getCharachterIndex(completionHandler: CompletionHandlerCharacters){
        
        if let url = NSURL(string:MarvelRequest.baseUrl+"characters")?.URLByAppendingQueryParams(getDeafultParams()){
            let request =  NSURLRequest(URL: url)
            ApiRepository().getMultipleObjects(request, mapperType: CharacterMapper.self, completionHandler: completionHandler)
        }
        
    }
    
    
    private static func getDeafultParams() -> [String: AnyObject]{
        let ts = Int(NSDate().timeIntervalSince1970)
        let hash = "\(ts)\(MarvelRequest.privateKey)\(MarvelRequest.publicKey)".md5()
        let params: [String: AnyObject] = [MarvelRequest.apiKey: MarvelRequest.publicKey, MarvelRequest.hashKey: hash, MarvelRequest.timestampKey:ts]
        return params
    }
}
