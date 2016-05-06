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

    
    
    struct StorageFilePaths {
        
        private static let characterThumbnailBasePath = StorageFilePaths.fileWithBasePath("characterThumbnails")
        
        static func characterThumbnailPath(name: String) -> String {
            return StorageFilePaths.fileWithBasePath(name, basePath: StorageFilePaths.characterThumbnailBasePath)
        }
        
        static func fileWithBasePath(file: String, basePath: String = FileStorageUtilities.storageBasePath) -> String {
            return [basePath, file].joinWithSeparator("/")
        }
    }
    
}




