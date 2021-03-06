//
//  marvelTests.swift
//  marvelTests
//
//  Created by khlebtsov alexey on 04/05/16.
//
//

import XCTest
@testable import marvel

class marvelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
    func getStringFromBundle(filename: String, key: String) -> String? {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        if let path = bundle.pathForResource(filename, ofType: "plist"){
            if let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                if let value = dict[key] as? String {
                    return value
                }
            }
        }
        
        return nil
    }

}
