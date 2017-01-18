//
//  ServerModelTests.swift
//  Pix500
//
//  Created by Nishant on 2016-03-15.
//  Copyright © 2016 Pix500. All rights reserved.
//

//import XCTest
//import Foundation
//@testable import Pix500
//
//class PxServerFetchTests: XCTestCase {
//    
//    let totalFourFetchedItems = 36
//    var serverConnectionHelper:ServerConnectionHelper?
//    
//    override func setUp() {
//        super.setUp()
//        
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        
//        self.serverConnectionHelper = ServerConnectionHelper()
//        
//        // After 4 fetches now the total number of objects in the PhotoArray (GridView) should be 144
//        
//
//        
//    }
//    
//    func testAFirstFetch()
//    {
//        // Declare our expectation
//        let readyExpectation = expectationWithDescription("ready")
//        
//        //1
//        self.serverConnectionHelper!.fetchPhotos(0, block: {(totalExpectedItems:Int) -> Void in
//
//            // Test the condition
//            XCTAssertEqual(totalExpectedItems, self.totalFourFetchedItems)
//            
//            // And fulfill the expectation...
//            readyExpectation.fulfill()
//        })
//        
//        // Loop until the expectation is fulfilled
//        waitForExpectationsWithTimeout(5, handler: { error in
//            XCTAssertNil(error, "Error")
//            
//            
//        })
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
//    
//}
