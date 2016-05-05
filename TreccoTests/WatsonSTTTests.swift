//
//  WatsonSTTTests.swift
//  Trecco
//
//  Created by Joshua Johanan on 5/2/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import XCTest
import BrightFutures
@testable import Trecco

class WatsonSTTTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBase64() {
        let http = HTTPMock(future: Future<NSData?, NSError>())
        let watson = WatsonSTT(username: "user", password: "pass", http: http)
        
        XCTAssert(watson.credentialsToBase64() == "dXNlcjpwYXNz")
        
        watson.processFileURL(NSURL(fileURLWithPath: "test"))
        //check that the autorization is sent in the request
        XCTAssert(http.headers!["Authorization"] == "Basic dXNlcjpwYXNz")
    }
    
    func testProcessFileURL() {
        let successPromise = Promise<NSData?, NSError>()
        
        let dataString = "{\"results\": [{\"alternatives\":[ { \"transcript\": \"hey\",\"confidence\": 0.75 } ]}], \"result_index\": 0}"
        let data = dataString.dataUsingEncoding(NSUTF8StringEncoding)
        
        successPromise.success(data)
        
        
        let http = HTTPMock(future: successPromise.future)
        let watson = WatsonSTT(username: "user", password: "pass", http: http)
        
        let expectation = expectationWithDescription("Success HTTP")
        let expectationFail = expectationWithDescription("Failure HTTP")
        
        watson.processFileURL(NSURL(fileURLWithPath: "test"))
            .onSuccess{result in
                XCTAssert(result != nil)
                expectation.fulfill()
            }
            .onFailure{ _ in
                XCTFail()
        }
        
        let failPromise = Promise<NSData?, NSError>()
        
        failPromise.failure(NSError(domain: "test", code: 1, userInfo: nil))
        
        
        let httpFail = HTTPMock(future: failPromise.future)
        let watsonFail = WatsonSTT(username: "user", password: "pass", http: httpFail)
        
        watsonFail.processFileURL(NSURL(fileURLWithPath: "test")).onSuccess{_ in XCTFail()}
            .onFailure{ error in
                XCTAssert(error.domain == "test")
                XCTAssert(error.code == 1)
                expectationFail.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
}

