//
//  ProcessView.swift
//  Trecco
//
//  Created by Joshua Johanan on 5/15/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit

protocol ProcessViewProtocol {
    func postToTrelloPressed(sender: UIButton)
}

class ProcessView: BaseView {
    
    @IBOutlet weak var textViewOutput: UITextView!
    @IBOutlet weak var buttonPostToTrello: UIButton!
    @IBOutlet weak var boardPicker: UIPickerView!
    var delegate: ProcessViewProtocol?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.buttonPostToTrello.enabled = false
        self.buttonPostToTrello.setTitleColor(UIColor.grayColor(), forState: .Disabled)
    }
    
    
    @IBAction func postToTrelloPressed(sender: UIButton) {
        self.delegate?.postToTrelloPressed(sender)
    }
    
}
