//
//  MainViewControllerTests.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/3/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import XCTest
@testable import Trecco

class MainViewControllerTests: XCTestCase {
    var mainViewController: MainViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mainViewController = MainViewController()
        _ = mainViewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateWarningAttributedString() {
        let justTrello = mainViewController.createWarningAttributedString(false, recordPermission: true)
        XCTAssert((justTrello.string == "Please connect to Trello\nYou will be able to sync your voice note to a Trello Board\n"),
            "String should only have Trello instructions")
        
        let justRecord = mainViewController.createWarningAttributedString(true, recordPermission: false)
        XCTAssert((justRecord.string == "Please allow Access to the Microphone\nYou will be able to create voice notes. After recording the note, it will be sent to IBM's Watson to be transcribed.\n"),
            "Should just have microphone instructions")
        
        let both = mainViewController.createWarningAttributedString(false, recordPermission: false)
        XCTAssert((both.string == "Please connect to Trello\nYou will be able to sync your voice note to a Trello Board\nPlease allow Access to the Microphone\nYou will be able to create voice notes. After recording the note, it will be sent to IBM's Watson to be transcribed.\n"),
            "Both should instructions")
        
        let neither = mainViewController.createWarningAttributedString(true, recordPermission: true)
        XCTAssert(neither.string.isEmpty == true)
    }
    
    func testSetInstructions() {
        let startView = mainViewController.view as! StartView
        
        mainViewController.setInstructions(false, recordPermission: true)
        XCTAssert((startView.instructions.text == "Please connect to Trello\nYou will be able to sync your voice note to a Trello Board\n"),
            "Instructions should be equal to attributed string")
    }
    
}
