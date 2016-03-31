//
//  ConnectedTrello.swift
//  Trecco
//
//  Created by Joshua Johanan on 3/30/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit

protocol ConnectedTrelloDelegate {
    func logOutOfTrello()
}

class ConnectedTrello: BaseView {
    @IBOutlet weak var trelloImage: UIImageView!
    @IBOutlet weak var trelloName: UILabel!
    @IBOutlet weak var logOutSwitch: UISwitch!
    
    var delegate: ConnectedTrelloDelegate?
    
    func UpdateImage(image: UIImage?) {
        trelloImage.image = image
    }
    
    func updateName(name: String) {
        trelloName.text = name
    }
    
    @IBAction func switchValueChange(sender: UISwitch) {
        //we are not going to handle this
        //if logged out this view will disappear
        logOutSwitch.setOn(true, animated: false)
        self.delegate?.logOutOfTrello()
    }
    
}

