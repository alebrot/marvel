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