//
//  StartViewTests.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/3/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import XCTest
@testable import Trecco

class StartViewTests: XCTestCase {
    var startView: StartView!
    
    override func setUp() {
        super.setUp()
        startView = StartView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNilImageData() {
        self.startView.createTrelloAuthenticatedView(nil, name: "Josh")
        
        let cttView = self.startView.cttView.subviews[0] as! ConnectedTrello
        XCTAssert(cttView.trelloName.text == "Josh")
        XCTAssert(cttView.trelloImage.image == nil)
    }
    
    func testDataImageData() {
        let image = UIImage(named: "IBM_Watson.png",
            inBundle: NSBundle(forClass: StartViewTests.self),
            compatibleWithTraitCollection: nil)
        
        self.startView.createTrelloAuthenticatedView(UIImagePNGRepresentation(image!), name: "Josh")
        let cttView = self.startView.cttView.subviews[0] as! ConnectedTrello
        //load a real file
        XCTAssert(cttView.trelloImage.image?.CGImage != nil)
    }
    
}
