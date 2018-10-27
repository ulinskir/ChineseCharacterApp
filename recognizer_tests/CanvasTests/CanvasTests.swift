//
//  CanvasTests.swift
//  CanvasTests
//
//  Created by Thomas (Tom) Parker on 9/22/18.
//  Copyright © 2018 Tom Parker. All rights reserved.
//

import XCTest
@testable import Canvas

class CanvasTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDown() {
        
    }

    func testExample() {
        let instanceOfRecognizer = Recognizer()
        let source:[(Double,Double)] = [(2,5),(15,5)];
        let target:[(Double,Double)] = [(2,5),(15,5)]
        let result = instanceOfRecognizer.recognize(source:source, target:target, offset: 0)

        XCTAssert(result.score == 0.0)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }   


    func testExample2() {
        let instanceOfRecognizer = Recognizer()
        let source:[(Double,Double)] = [(2,5),(9,6),(15,5)];
        let target:[(Double,Double)] = [(2,5),(15,5)]
        let result = instanceOfRecognizer.recognize(source:source, target:target, offset: 0)
        
        XCTAssert(result.score == 0.0)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
    }
}


