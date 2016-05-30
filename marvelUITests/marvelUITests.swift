//
//  marvelUITests.swift
//  marvelUITests
//
//  Created by khlebtsov alexey on 04/05/16.
//
//

import XCTest

class marvelUITests: XCTestCase {
    let timeOut = 5.0
    
    let loadMoreLimit:UInt = 20
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        app.terminate()
    }

    private func waitForElementToAppear(element: XCUIElement) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectationForPredicate(existsPredicate,
                                evaluatedWithObject: element, handler: nil)
        waitForExpectationsWithTimeout(timeOut, handler: nil)
    }
    
    func testCharacterListLoadMore() {
        let table = app.tables.elementBoundByIndex(0)
        XCTAssert(table.cells.count == 0)
        sleep(1)
        XCTAssert(table.cells.count == loadMoreLimit)
        let lastCell = table.cells.elementBoundByIndex(table.cells.count-1)
        table.scrollToElement(lastCell)
        sleep(1)
        XCTAssert(table.cells.count <= loadMoreLimit * 2)
    }
    
    func testSearch(){
        app.navigationBars["marvel.CharactersIndexView"].buttons["Search"].tap()
        app.searchFields["Search"].tap()
        app.keys["A"].tap()
        
        let searchTable = app.tables["Search results"]
        let expectedElement = searchTable.cells.staticTexts["A.I.M."]
        waitForElementToAppear(expectedElement)
        XCTAssertTrue(expectedElement.exists)
        
        app.tables["Search results"].staticTexts["A.I.M."].tap()
        app.tables.buttons["ImageBack"].tap()
        app.buttons["Cancel"].tap()
    }
    
    
    func testSearchLoadMore() {
        
        app.navigationBars["marvel.CharactersIndexView"].buttons["Search"].tap()
        app.searchFields["Search"].tap()
        
        let table = app.tables["Search results"]
        XCTAssert(table.cells.count == 0)
        
        app.keys["A"].tap()
        sleep(1)
        XCTAssert(table.cells.count == loadMoreLimit)
        let lastCell = table.cells.elementBoundByIndex(table.cells.count-1)
        table.scrollToElement(lastCell)
        sleep(1)
        XCTAssert(table.cells.count <= loadMoreLimit * 2)
    }
    
    
    func testCollectionView(){
        let tablesQuery = app.tables
        tablesQuery.staticTexts["A.I.M."].tap()
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(2).tap()
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        app.buttons["ImageClose"].tap();
        tablesQuery.buttons["ImageBack"].tap()
    }
    
    
}
