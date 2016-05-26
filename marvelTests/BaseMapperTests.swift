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
        
    }
    
    
}
