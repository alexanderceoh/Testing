//
//  TestingTests.swift
//  TestingTests
//
//  Created by alex oh on 2/16/16.
//  Copyright © 2016 Alex Oh. All rights reserved.
//

import XCTest
@testable import Testing

class TestingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFullName() {
        var me = User()
        me.firstName = "Bart"
        me.lastName = "Jacobs"
        
        XCTAssertEqual(me.fullName, "Bart Jacobs", "The full name is incorrect")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
