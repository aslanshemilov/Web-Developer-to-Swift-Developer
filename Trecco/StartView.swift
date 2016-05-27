//
//  StartView.swift
//  Trecco
//
//  Created by Joshua Johanan on 3/28/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit

protocol StartViewProtocol: ConnectedTrelloDelegate {
    func recordPressed(sender: UIButton)
    func trelloOAuthSend(sender: UIButton!)
}

class StartView: BaseView {
    @IBOutlet weak var cttView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var startRecordButton: UIButton!
    var instructions: UILabel = UILabel()
    
    var delegate: StartViewProtocol?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setUpInstructions()
    }
    
    @IBAction func recordPressed(sender: UIButton) {
        self.delegate?.recordPressed(sender)
    }
    
    func trelloOAuthSend(sender: UIButton!) {
        self.delegate?.trelloOAuthSend(sender)
    }
    
    func createTrelloAuthenticatedView(image: NSData?, name: String) {
        //clean up subviews
        cttView.subviews.forEach{ $0.removeFromSuperview()}
        
        let ctt = ConnectedTrello()
        ctt.delegate = self.delegate
        ctt.translatesAutoresizingMaskIntoConstraints = false
        self.cttView.addSubview(ctt)
        LayoutFunctions.activateConstraintsForView(ctt, parentView: self.cttView)
        if let image = image {
            ctt.UpdateImage(UIImage(data: image))
        }
        ctt.updateName(name)
    }
    
    func createTrelloLoginButton() {
        cttView.subviews.forEach{ $0.removeFromSuperview()}
        
        let cttButton = UIButton()
        cttButton.addTarget(self, action: "trelloOAuthSend:", forControlEvents: .TouchUpInside)
        let trelloImage = UIImage(named: "Trello-logo-white")
        cttButton.setImage(trelloImage, forState: .Normal)
        cttButton.translatesAutoresizingMaskIntoConstraints = false
        cttView.addSubview(cttButton)
        let offCenter = NSLayoutConstraint(item: cttButton,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: cttView,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 44.0)
        
        LayoutFunctions.verticallyCenterView(cttButton, parentView: cttView)
        
        let textButton = UIButton()
        textButton.setTitle("Connect to", forState: .Normal)
        textButton.addTarget(self, action: "trelloOAuthSend:", forControlEvents: .TouchUpInside)
        textButton.translatesAutoresizingMaskIntoConstraints = false
        cttView.addSubview(textButton)
        LayoutFunctions.verticallyCenterView(textButton, parentView: cttView)
        let leftOfTrello = NSLayoutConstraint(item: textButton,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: cttButton,
            attribute: .Leading,
            multiplier: 1.0,
            constant: -4.0)
        NSLayoutConstraint.activateConstraints([leftOfTrello, offCenter])
    }
    
    func setUpInstructions(){
        //place the instruction label
        instructions.numberOfLines = 0
        self.view.addSubview(instructions)
        instructions.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: instructions,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: cttView,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 8.0)
        
        let left = NSLayoutConstraint(item: instructions,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: cttView,
            attribute: .Leading,
            multiplier: 1.0,
            constant: 16.0)
        
        
        let right = NSLayoutConstraint(item: instructions,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: cttView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: -16.0)
        
        
        NSLayoutConstraint.activateConstraints([top, left, right])
    }
    
    func updateInstructions(instruct: NSAttributedString) {
        self.instructions.attributedText = instruct
    }


}
