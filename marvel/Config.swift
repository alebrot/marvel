//
//  Config.swift
//  marvel
//
//  Created by khlebtsov alexey on 04/05/16.
//
//

import Foundation


struct Config {
    struct Keys{
        static let marvelPublic = CommonUtilities.getStringFromMainBundle("MarvelPublicKey")!
        static let marvelPrivate = CommonUtilities.getStringFromMainBundle("MarvelPrivateKey")!
    }
    
    static let baseUrl = CommonUtilities.getStringFromMainBundle("BaseUrl")!
    
    
    
    
    struct TableView {
        
        struct CellIdentifiers {
            static let CharacterCell = "CharacterCell"
        }
        
        static var listLoadLimit = 20;
        
    }

    
    
}



class CommonUtilities {
    static func getStringFromMainBundle(key: String) -> String? {
        if let infoPlist = NSBundle.mainBundle().infoDictionary {
            if let apiURL = infoPlist[key] as? String {
                return apiURL
            }
        }
        return nil
    }
}