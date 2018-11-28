//
//  ChineseCharacterAppTests.swift
//  ChineseCharacterAppTests
//
//  Created by Risa Ulinski on 9/22/18.
//  Copyright © 2018 Hamilton College CS Senior Seminar. All rights reserved.
//

import XCTest
@testable import ChineseCharacterApp

class ChineseCharacterAppTests: XCTestCase {

    override func setUp() {
//        let ice = ["M 337 94 C 322 90 237 56 214 40", "M 339 141 C 324 137 244 105 221 89"]

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFirst_doesnt_match() {
        let ice = ["M 337 94 C 322 90 237 56 214 40", "M 339 141 C 324 137 244 105 221 89"]
        
        let _matcher = Matcher()
        let src = _matcher.processTargetPoints(ice, destDimensions: (0,335,335,0))
        let res = _matcher.full_matcher(source:[[(0,0),(5,5)],src[1]],target:src)
        print(res)
        XCTAssert(res[1][1] ==true, "second stroke not found when first stroke is wrong")
        
    }

    func test_matcher_same_inputs() {
        let ice = ["M 337 94 C 322 90 237 56 214 40", "M 339 141 C 324 137 244 105 221 89"]

        let _matcher = Matcher()
        let src = _matcher.processTargetPoints(ice, destDimensions: (0,335,335,0))
        let res = _matcher.full_matcher(source:src,target:src)
        for stroke in res {
            XCTAssert(stroke == (true,true,true))
        }
    }
    func test_recognizer() {
        let ice = ["M 337 94 C 322 90 237 56 214 40", "M 339 141 C 324 137 244 105 221 89"]

        let _rec = Recognizer()
        let _matcher = Matcher()
        let src = _matcher.processTargetPoints(ice, destDimensions: (0,335,335,0))
        for stroke in src {
            let res = _rec.recognize(source:stroke, target: stroke, offset: 0)
            XCTAssert(res.score != -Double.infinity)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
