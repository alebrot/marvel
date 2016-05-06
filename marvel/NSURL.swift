//
//  NSURL.swift
//  marvel
//
//  Created by khlebtsov alexey on 05/05/16.
//
//

import Foundation


extension NSURL{
    func URLByAppendingQueryParams(params:[String: AnyObject])->NSURL{
        if let components=NSURLComponents(URL: self, resolvingAgainstBaseURL: true){
            
            var queryItems=[NSURLQueryItem]()
            for (key, value) in params {
                let stringValue = "\(value)"
                let queryItem=NSURLQueryItem(name: key, value: stringValue)
                queryItems.append(queryItem)
            }
            components.queryItems=queryItems
            if let url=components.URL{
                return url
            }
        }
        return self
    }
    
    static func fromString(urlString: String?) -> NSURL? {
        if urlString != nil {
            return NSURL(string: urlString!)
        }
        return nil
    }
}