//
//  ResponseMappingTests.swift
//  Trecco
//
//  Created by Joshua Johanan on 5/4/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import XCTest
@testable import Trecco

class ResponseMappingTests: XCTestCase {
    
    func testToWatsonResults() {
        let dataString = "{\"results\": [{\"alternatives\":[ { \"transcript\": \"hey\",\"confidence\": 0.75 } ]}], \"result_index\": 0}"
        let data = dataString.dataUsingEncoding(NSUTF8StringEncoding)
        let result = ResponseMapping.ToWatsonResults(data)!
        
        XCTAssert((result.transcript == "hey"), "transcript should be hey")
        
        let blankResult = ResponseMapping.ToWatsonResults(nil)
        
        XCTAssert((blankResult == nil), "Blank result")
    }
    
    func testToTrelloMember() {
        let json = "{\"id\": \"1234\", \"avatarHash\": \"hash\", \"fullName\": \"name\"}"
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)
        let me = ResponseMapping.ToTrelloMember(data)!
        
        XCTAssert((me.id == "1234"), "ID should be 1234")
        XCTAssert((me.avatarHash == "hash"), "hash should be hash")
        XCTAssert((me.fullName == "name"), "name should be name")
        
        let blankMe = ResponseMapping.ToTrelloMember(nil)
        XCTAssert((blankMe == nil), "should be nil")
    }
    
    func testToTrelloBoard() {
        let json = "{\"id\": \"1234\", \"name\": \"test\", \"closed\": false}"
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)
        let board = ResponseMapping.ToTrelloBoard(data)!
        
        XCTAssert((board.id == "1234"), "id should be 1234")
        XCTAssert((board.closed == false), "board should not be closed")
        XCTAssert((board.name == "test"), "name should be test")
        
        let blankBoard = ResponseMapping.ToTrelloBoard(nil)
        XCTAssert((blankBoard == nil), "board should be nil")
    }
    
    func testToTrelloBoardArray() {
        let json = "[{\"id\": \"1234\", \"name\": \"test\", \"closed\": false}, {\"id\": \"4321\", \"name\": \"second\", \"closed\": true}]"
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)
        let boards = try! ResponseMapping.ToTrelloBoardArray(data)
        
        XCTAssert((boards.count == 2), "should have one member")
        XCTAssert((boards[0].id == "1234"), "id should be 1234")
        XCTAssert((boards[0].closed == false), "board should not be closed")
        XCTAssert((boards[0].name == "test"), "name should be test")
        XCTAssert((boards[1].id == "4321"), "id should be 4321")
        XCTAssert((boards[1].closed == true), "board should be closed")
        XCTAssert((boards[1].name == "second"), "name should be second")
        
        let blankBoards = try! ResponseMapping.ToTrelloBoardArray(nil)
        XCTAssert((blankBoards.count == 0), "should be no boards")
    }
    
    func testToTrelloList() {
        let json = "{\"id\": \"1234\", \"name\": \"test\", \"closed\": false, \"idBoard\": \"board1234\"}"
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)
        let list = ResponseMapping.ToTrelloList(data)!
        
        XCTAssert((list.id == "1234"), "id should be 1234")
        XCTAssert((list.name == "test"), "name should be test")
        XCTAssert((list.closed == false), "should not be closed")
        XCTAssert((list.idBoard == "board1234"), "idBoard should be board1234")
        
        let blankList = ResponseMapping.ToTrelloList(nil)
        XCTAssert((blankList == nil), "list should be nil")
    }
    
    func testToTrelloListArrary() {
        let json = "[{\"id\": \"1234\", \"name\": \"test\", \"closed\": false, \"idBoard\": \"board1234\"}]"
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)
        let lists = try! ResponseMapping.ToTrelloListArray(data)
        
        XCTAssert((lists.count == 1), "should be one")
        XCTAssert((lists[0].id == "1234"), "id should be 1234")
        XCTAssert((lists[0].name == "test"), "name should be test")
        XCTAssert((lists[0].closed == false), "should not be closed")
        XCTAssert((lists[0].idBoard == "board1234"), "idBoard should be board1234")
        
        let blankLists = try! ResponseMapping.ToTrelloListArray(nil)
        XCTAssert((blankLists.count == 0), "shoudl be zero")
    }
    
    func testToTrelloCard() {
        let json = "{\"id\": \"cardid\", \"name\": \"card\", \"desc\": \"carddesc\", \"shortUrl\": \"url\", \"idBoard\": \"1234\", \"idList\": \"4321\"}"
        let data = json.dataUsingEncoding(NSUTF8StringEncoding)
        let card = ResponseMapping.ToTrelloCard(data)!
        
        XCTAssert(card.id == "cardid")
        XCTAssert(card.name == "card")
        XCTAssert(card.desc == "carddesc")
        XCTAssert(card.shortUrl == "url")
        XCTAssert(card.idBoard == "1234")
        XCTAssert(card.idList == "4321")
        
        let blankCard = ResponseMapping.ToTrelloCard(nil)
        XCTAssert(blankCard == nil)
    }
    
}
