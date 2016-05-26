//
//  MarvelRequest.swift
//  marvel
//
//  Created by khlebtsov alexey on 24/05/16.
//
//

import XCTest
@testable import marvel

class MarvelRequestTests: marvelTests {

    let timeOut = 5.0
    let limit = 10
    
    func testGetCharachterIndex(){
        
        let asyncExpectation = expectationWithDescription("ApiRequest")
        var characters: [marvel.Character]?
        
        MarvelRequest.getCharachterIndex(limit, offset: 0) { (ok: Bool, objects: [marvel.Character]?, error: NSError?) in
            characters = objects
            asyncExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeOut) { (error: NSError?) in
            XCTAssertNil(error, "Something went horribly wrong")
            XCTAssertNotNil(characters, "Something went wrong")
            XCTAssertEqual(characters!.count, self.limit)
        }
    }
    
    
    func testGetCharachterSearch(){
        
        let asyncExpectation = expectationWithDescription("ApiRequest")
        var characters: [marvel.Character]?
        
        let searchText = "a"
        
        MarvelRequest.getCharachterSearch(searchText, limit: limit, offset: 0) { (ok, objects, error) in
            characters = objects
            asyncExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeOut) { (error: NSError?) in
            XCTAssertNil(error, "Something went horribly wrong")
            XCTAssertNotNil(characters, "Something went wrong")
            for character in characters!{
                XCTAssertNotNil(character.name.lowercaseString.rangeOfString(searchText), "Wrong search results")
            }
        }
    }

}
