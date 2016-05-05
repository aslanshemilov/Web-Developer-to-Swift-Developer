//
//  TrelloAPITests.swift
//  Trecco
//
//  Created by Joshua Johanan on 5/2/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import XCTest
import BrightFutures
@testable import Trecco

class TrelloAPITests: XCTestCase {
    var http: HTTPMock?
    var promise: Promise<NSData?, NSError>?
    var api: TrelloAPI?
    
    override func setUp() {
        super.setUp()
        self.promise = Promise<NSData?, NSError>()
        self.http = HTTPMock(future: self.promise!.future)
        self.api = TrelloAPI(key: "key", token: "token", http: self.http!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIfTokenAndKeyAreSent() {
        self.api!.getMe()
        
        XCTAssert(self.http!.params!["key"] as! String == "key")
        XCTAssert(self.http!.params!["token"] as! String == "token")
        
        self.api!.getBoards()
        
        XCTAssert(self.http!.params!["key"] as! String == "key")
        XCTAssert(self.http!.params!["token"] as! String == "token")
        
        self.api!.getListsForBoard("1234")
        
        XCTAssert(self.http!.params!["key"] as! String == "key")
        XCTAssert(self.http!.params!["token"] as! String == "token")
        
    }
    
    func testGetMeSuccess() {
        self.api!.getMe()
        
        XCTAssert(self.http!.url == "https://api.trello.com/1/members/me")
        
        let expectation = expectationWithDescription("Success HTTP")
        
        self.promise!.success("{\"id\": \"1234\", \"avatarHash\": \"hash\", \"fullName\": \"name\"}".dataUsingEncoding(NSUTF8StringEncoding))
        
        self.api!.getMe()
            .onSuccess{member in
                XCTAssert(member.id == "1234")
                expectation.fulfill()
            }
            .onFailure{error in XCTFail()}
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testGetMeFail() {
        let expectation = expectationWithDescription("Failure HTTP")
        
        self.promise!.failure(NSError(domain: "test", code: 1, userInfo: [:]))
        
        self.api!.getMe()
            .onSuccess{member in
                XCTFail()
            }
            .onFailure{error in
                XCTAssert(error.domain == "test")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testGetBoardsSuccess() {
        self.api!.getBoards()
        
        XCTAssert(self.http!.url == "https://api.trello.com/1/members/me/boards")
        
        let expectation = expectationWithDescription("Success HTTP")
        
        self.promise!.success(
            "[{\"id\": \"1234\", \"name\": \"test\", \"closed\": false}, {\"id\": \"4321\", \"name\": \"second\", \"closed\": true}]".dataUsingEncoding(NSUTF8StringEncoding))
        
        self.api!.getBoards()
            .onSuccess{boards in
                XCTAssert(boards.count == 2)
                expectation.fulfill()
            }
            .onFailure{error in XCTFail()}
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testGetBoardsFailure() {
        let expectation = expectationWithDescription("Failure HTTP")
        
        self.promise!.failure(NSError(domain: "test", code: 1, userInfo: [:]))
        
        self.api!.getBoards()
            .onSuccess{boards in
                XCTFail()
            }
            .onFailure{error in
                XCTAssert(error.domain == "test")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testGetListsForBoardSuccess() {
        self.api!.getListsForBoard("1234")
        
        XCTAssert(self.http!.url == "https://api.trello.com/1/boards/1234/lists")
        
        let expectation = expectationWithDescription("Success HTTP")
        
        self.promise!.success(
            "[{\"id\": \"1234\", \"name\": \"test\", \"closed\": false, \"idBoard\": \"board1234\"}]".dataUsingEncoding(NSUTF8StringEncoding))
        
        self.api!.getListsForBoard("1234")
            .onSuccess{lists in
                XCTAssert(lists.count == 1)
                expectation.fulfill()
            }
            .onFailure{error in XCTFail()}
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testGetListsForBoardFailure() {
        let expectation = expectationWithDescription("Failure HTTP")
        
        self.promise!.failure(NSError(domain: "test", code: 1, userInfo: [:]))
        
        self.api!.getListsForBoard("1234")
            .onSuccess{lists in
                XCTFail()
            }
            .onFailure{error in
                XCTAssert(error.domain == "test")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testCreateCardSuccess() {
        self.api!.createCard(TrelloCreateCard(idList: "1234", name: "test"))
        
        XCTAssert(self.http!.url == "https://api.trello.com/1/cards?key=key&token=token")
        
        let expectation = expectationWithDescription("Success HTTP")
        
        self.promise!.success(
            "{\"id\": \"cardid\", \"name\": \"card\", \"desc\": \"carddesc\", \"shortUrl\": \"url\", \"idBoard\": \"1234\", \"idList\": \"4321\"}".dataUsingEncoding(NSUTF8StringEncoding))
        
        self.api!.createCard(TrelloCreateCard(idList: "1234", name: "test"))
            .onSuccess{card in
                XCTAssert(card.id == "cardid")
                expectation.fulfill()
            }
            .onFailure{error in XCTFail()}
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testCreateCardSuccessBlank() {
        let expectation = expectationWithDescription("Success HTTP")
        
        self.promise!.success(nil)
        
        self.api!.createCard(TrelloCreateCard(idList: "1234", name: "test"))
            .onSuccess{card in XCTFail()}
            .onFailure{error in
                XCTAssert(true)
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testCreateCardFailure() {
        let expectation = expectationWithDescription("Failure HTTP")
        
        self.promise!.failure(NSError(domain: "test", code: 1, userInfo: [:]))
        
        self.api!.createCard(TrelloCreateCard(idList: "1234", name: "test"))
            .onSuccess{lists in
                XCTFail()
            }
            .onFailure{error in
                XCTAssert(true)
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testgetBoardswithListsSuccess() {
        let expectation = expectationWithDescription("Success HTTP")
        
        let boards = Promise<NSData?, NSError>()
        boards.success(("[{\"id\": \"1234\", \"name\": \"test\", \"closed\": false}, {\"id\": \"1234\", \"name\": \"second\", \"closed\": false}," +
            "{\"id\": \"4321\", \"name\": \"second\", \"closed\": true}]").dataUsingEncoding(NSUTF8StringEncoding))
        
        let list = Promise<NSData?, NSError>()
        list.success(("[{\"id\": \"1234\", \"name\": \"test\", \"closed\": false, \"idBoard\": \"board1234\"}," +
            "{\"id\": \"1234\", \"name\": \"test\", \"closed\": true, \"idBoard\": \"board1234\"}]").dataUsingEncoding(NSUTF8StringEncoding))
        
        let routes: [String: Future<NSData?, NSError>] =
        ["https://api.trello.com/1/members/me/boards": boards.future, "https://api.trello.com/1/boards/1234/lists": list.future]
        
        self.http!.futures = routes
        
        self.api!.getAllListsForAllBoards()
            .onSuccess{boards in
                XCTAssert(boards.count == 2)
                XCTAssert(boards[0].list.count == 1)
                XCTAssert(boards[1].list.count == 1)
                expectation.fulfill()
            }
            .onFailure{error in XCTFail()}
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testGetBoardsWithListsBoardFailure() {
        let expectation = expectationWithDescription("Failure HTTP")
        
        let boards = Promise<NSData?, NSError>()
        boards.failure(NSError(domain: "test", code: 1, userInfo: [:]))
        
        let list = Promise<NSData?, NSError>()
        
        let routes: [String: Future<NSData?, NSError>] =
        ["https://api.trello.com/1/members/me/boards": boards.future, "https://api.trello.com/1/boards/1234/lists": list.future]
        
        self.http!.futures = routes
        
        self.api!.getAllListsForAllBoards()
            .onSuccess{boars in XCTFail()}
            .onFailure{error in
                XCTAssert(error.domain == "test")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testGetBoardsWithListsListFailure() {
        let expectation = expectationWithDescription("Failure HTTP")
        
        let boards = Promise<NSData?, NSError>()
        boards.success(("[{\"id\": \"1234\", \"name\": \"test\", \"closed\": false}, {\"id\": \"1234\", \"name\": \"second\", \"closed\": false}]").dataUsingEncoding(NSUTF8StringEncoding))
        
        let list = Promise<NSData?, NSError>()
        list.failure(NSError(domain: "test", code: 1, userInfo: [:]))
        
        let routes: [String: Future<NSData?, NSError>] =
        ["https://api.trello.com/1/members/me/boards": boards.future, "https://api.trello.com/1/boards/1234/lists": list.future]
        
        self.http!.futures = routes
        
        self.api!.getAllListsForAllBoards()
            .onSuccess{boars in XCTFail()}
            .onFailure{error in
                XCTAssert(error.domain == "test")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    
}

