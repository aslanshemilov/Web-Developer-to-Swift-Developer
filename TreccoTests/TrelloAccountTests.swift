//
//  TrelloAccountTests.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/14/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import XCTest
@testable import Trecco

class MockUserDefaults : UserDefaultsProtocol {
    var storageDict: [String:AnyObject?] = [:]
    
    func stringForKey(defaultName: String) -> String? {
        return storageDict[defaultName] as? String
    }
    
    func setObject(value: AnyObject?, forKey: String) {
        storageDict[forKey] = value
    }
    
    func removeObjectForKey(defaultName: String) {
        storageDict.removeValueForKey(defaultName)
    }
}

class TrelloAccountTests: XCTestCase {
    var userDefaults: UserDefaultsProtocol!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userDefaults = MockUserDefaults()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testisTrelloConnected() {
        let trelloAccount = TrelloAccount(defaultObject: userDefaults)
        XCTAssert((trelloAccount.isTrelloConnected() == false), "Should not be connected")
        
        //set blank tocken
        userDefaults.setObject("", forKey: GlobalConstants.TRELLO_TOKEN)
        XCTAssert((trelloAccount.isTrelloConnected() == false), "Should not be connected with blank token")
        
        //set a token
        userDefaults.setObject("token", forKey: GlobalConstants.TRELLO_TOKEN)
        XCTAssert((trelloAccount.isTrelloConnected() == true), "Any value should be true")
    }
    
    func testgetTrelloAvatarHash() {
        let trelloAccount = TrelloAccount(defaultObject: userDefaults)
        userDefaults.setObject("hash", forKey: GlobalConstants.TRELLO_AVATAR)
        
        XCTAssert((trelloAccount.getTrelloAvatarHashURL("http://test.com/") == "http://test.com/hash/50.png"),
            "should append the hash and then 50.png")
    }
    
}

