//
//  TrelloBoardPickerSourceTests.swift
//  Trecco
//
//  Created by Joshua Johanan on 5/14/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import XCTest
@testable import Trecco

class TrelloBoardPickerSourceTests: XCTestCase {
    var pickerSource: TrelloBoardPickerSource!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let boards = [
            TrelloBoardWithList(board: TrelloBoard(name: "Board1", closed: false, id: "board1"),
                list: [TrelloList(id: "list1", name: "List1", idBoard: "board1", closed: false)]),
            TrelloBoardWithList(board: TrelloBoard(name: "Board2", closed: false, id: "board2"),
                list: [TrelloList(id: "list2", name: "List2", idBoard: "board2", closed: false),
                    TrelloList(id: "list3", name: "List3", idBoard: "board2", closed: false)]),
        ]
        pickerSource = TrelloBoardPickerSource(boards: boards)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNumberofComponents() {
        XCTAssert(pickerSource.numberOfComponentsInPickerView(UIPickerView()) == 2)
    }
    
    func testNumberofRows() {
        let pickerView = UIPickerView()
        pickerView.dataSource = pickerSource
        
        pickerView.selectRow(0, inComponent: 0, animated: false)
        XCTAssert(pickerSource.pickerView(pickerView, numberOfRowsInComponent: 0) == 2)
        XCTAssert(pickerSource.pickerView(pickerView, numberOfRowsInComponent: 1) == 1)
        
        pickerView.selectRow(1, inComponent: 0, animated: false)
        XCTAssert(pickerSource.pickerView(pickerView, numberOfRowsInComponent: 1) == 2)
    }
    
    func testTitleForRow() {
        let pickerView = UIPickerView()
        pickerView.dataSource = pickerSource
        
        XCTAssert(pickerSource.pickerView(pickerView, titleForRow: 0, forComponent: 0) == "Board1")
        XCTAssert(pickerSource.pickerView(pickerView, titleForRow: 0, forComponent: 1) == "List1")
        
        pickerView.selectRow(1, inComponent: 0, animated: false)
        XCTAssert(pickerSource.pickerView(pickerView, titleForRow: 1, forComponent: 0) == "Board2")
        XCTAssert(pickerSource.pickerView(pickerView, titleForRow: 0, forComponent: 1) == "List2")
        XCTAssert(pickerSource.pickerView(pickerView, titleForRow: 1, forComponent: 1) == "List3")
    }
    
    func testGetList() {
        XCTAssert(pickerSource.getList(0, listRow: 0) == "list1")
        XCTAssert(pickerSource.getList(1, listRow: 0) == "list2")
        XCTAssert(pickerSource.getList(1, listRow: 1) == "list3")
    }
    
}