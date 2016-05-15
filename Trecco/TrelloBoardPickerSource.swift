//
//  TrelloBoardPickerSource.swift
//  Trecco
//
//  Created by Joshua Johanan on 5/14/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import Foundation
import UIKit

class TrelloBoardPickerSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var boards: [TrelloBoardWithList]!
    
    init(boards: [TrelloBoardWithList]) {
        self.boards = boards
    }
    
    func getList(boardRow: Int, listRow: Int) -> String {
        return self.boards[boardRow].list[listRow].id
    }
    
    // MARK: PickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.boards.count == 0 {
            return 0
        }
        
        switch(component) {
        case 0:
            return self.boards.count
        case 1:
            return self.boards[pickerView.selectedRowInComponent(0)].list.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.boards[row].board.name
        }
        
        return self.boards[pickerView.selectedRowInComponent(0)].list[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadComponent(1)
    }
    
}