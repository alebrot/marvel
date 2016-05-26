//
//  BaseMapperTests.swift
//  marvel
//
//  Created by khlebtsov alexey on 26/05/16.
//
//

import XCTest

@testable import marvel

class BaseMapperTests: marvelTests {
    
    func testCharacterMapper(){
        //setup
        
        let dateFormatter = Utilities.typeConversion.getDateFormatter(TypeConversionUtilities.ISO8601)
        
        let jsonString = getStringFromBundle("Json", key: "characters")
        XCTAssertNotNil(jsonString, "Failed to load json form plist")
        
        let  jsonData = jsonString!.dataUsingEncoding(NSUTF8StringEncoding)
        XCTAssertNotNil(jsonData, "Failed to create data object from json string")
        
        let dictionary = jsonData!.toDictionary()
        XCTAssertNotNil(dictionary, "Failed to create dictionary from data object")
        
        let givenDataDict = dictionary![CharacterMapper.dataKey]  as? Dictionary<String, AnyObject>
        XCTAssertNotNil(givenDataDict, "Failed to get data dictionary for key: 'data'")
        
        let givenArrayDict = givenDataDict![CharacterMapper.resultsKey] as? NSArray
        XCTAssertNotNil(givenArrayDict, "Failed to get array dictionary for key: 'result'")
        
        //execute
        let arrayDictExpected = CharacterMapper.getRoot(dictionary!) as? NSArray
        XCTAssertNotNil(arrayDictExpected, "Failed to locate the root of the array to be mapped")
        let objectsExpected = CharacterMapper.createArrayFrom(arrayDictExpected!)
        
        //check
        XCTAssertNotNil(objectsExpected, "Objects were not mapped")
        XCTAssertTrue(givenArrayDict!.count == objectsExpected!.count, "Number of objects in json doesn't correspond to the number of mapped objects")
        XCTAssertTrue(objectsExpected!.count > 0, "Zero mapped objects")
        
        
        XCTAssertTrue(objectsExpected![0].id == givenArrayDict![0][CharacterMapper.idKey], "Mapped object id is wrong")
        XCTAssertTrue(objectsExpected![0].name == givenArrayDict![0][CharacterMapper.nameKey], "Mapped object name is wrong")
        XCTAssertTrue(objectsExpected![0].desc == givenArrayDict![0][CharacterMapper.descriptionKey], "Mapped object description is wrong")
        
        let givenDictFirstObject = givenArrayDict![0] as? Dictionary<String, AnyObject>
        let modifiedString = givenDictFirstObject![CharacterMapper.modifiedKey] as? String
        let modified = Utilities.typeConversion.getNSDateFromString(modifiedString, dateFormatter: dateFormatter)
        XCTAssertTrue(objectsExpected![0].modified == modified, "Mapped object modified is wrong")

        let givenResourceURI = NSURL.fromString(givenDictFirstObject![CharacterMapper.resourceURIKey] as? String)
        XCTAssertTrue(objectsExpected![0].resourceURI == givenResourceURI, "Mapped object resourceURI is wrong")
        
    }
    
}
