//
//  RecordView.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/4/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit

protocol RecordViewProtocol {
    func stopRecordingEarly(sender: UIButton)
}

class RecordView: BaseView {
    @IBOutlet weak var labelCounter: UILabel!
    
    var delegate: RecordViewProtocol?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    @IBAction func stopRecordingEarly(sender: UIButton) {
        self.delegate?.stopRecordingEarly(sender)
    }
    
    func setRecordingTime(time_left: String) {
        self.labelCounter.text = time_left
    }
    
}

