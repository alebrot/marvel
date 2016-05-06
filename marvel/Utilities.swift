//
//  Utilities.swift
//  marvel
//
//  Created by khlebtsov alexey on 05/05/16.
//
//

import Foundation

struct Utilities {
    static let typeConversion = TypeConversionUtilities()
    static let queues = QueueUtilities()
    static let fileStorage = FileStorageUtilities()

}

struct TypeConversionUtilities{
    
    private var dateFormatter = NSDateFormatter()
    
    static let ISO8601 = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    
    func getDateFormatter(format: String = "yyyy-MM-dd HH:mm:ss")->NSDateFormatter{
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
    func getNSDateFromString(dateString: String?, dateFormatter: NSDateFormatter) -> NSDate? {
        if dateString != nil {
            return dateFormatter.dateFromString(dateString!)
        }
        return nil
    }
    
}

class QueueUtilities {
    let asyncQueue: NSOperationQueue
    init() {
        self.asyncQueue = NSOperationQueue()
        self.asyncQueue.name = "Async"
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

class FileStorageUtilities {
    
    static let storageBasePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    
    func saveFile(data: NSData, path: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        
        do {
            //create a direcory
            let directory = (path as NSString).stringByDeletingLastPathComponent
            try fileManager.createDirectoryAtPath(directory, withIntermediateDirectories: true, attributes: nil)
        } catch _ as NSError {
            
        } catch {
        }
        return fileManager.createFileAtPath(path, contents: data, attributes: nil)
    }
    
    func getFile(path: String) -> NSData? {
        let data = NSData(contentsOfFile: path)
        return data;
    }
    
    func fileExists(path: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath(path)
    }
    
    func removeFile(path: String) -> Bool {
        var ok = false
        let fileManager = NSFileManager.defaultManager()
        do {
            //create a direcory
            try fileManager.removeItemAtPath(path)
            ok = true
        } catch _ as NSError {
            
        } catch {
        }
        return ok
    }
    
    
    func removeDirectoryContent(path: String) -> Bool {
        
        
        var ok = false
        let fileManager = NSFileManager.defaultManager()
        
        
        do {
            //create a direcory
            let filelist = try fileManager.contentsOfDirectoryAtPath(path)
            if filelist.count == 0 {
                ok = true
            } else {
                for filename in filelist {
                    let filePath = Config.StorageFilePaths.fileWithBasePath(filename, basePath: path)
                    ok = true && self.removeFile(filePath)
                }
            }
        } catch _ as NSError {
            
        } catch {
        }
        return ok
    }
    
}