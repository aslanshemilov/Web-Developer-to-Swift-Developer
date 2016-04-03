//
//  MainViewController.swift
//  Trecco
//
//  Created by Joshua Johanan on 3/26/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, StartViewProtocol {
    var infoLoaded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Trecco"
        self.view = StartView()
        (self.view as! StartView).delegate = self
        
        //ask for record permission
        let avSession: AVAudioSession = AVAudioSession.sharedInstance()
        if(avSession.respondsToSelector("requestRecordPermission:")){
            avSession.requestRecordPermission({(granted: Bool) -> Void in self.updateInstructionsAndRecord()})
        }
        
        //setup Trello auth Finish
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "trelloAuthFinish:", name: GlobalConstants.TRELLO_AUTH_FINISH, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "trelloLoadInfo:", name: GlobalConstants.TRELLO_LOAD_INFO, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: StartViewProtocol
    func recordPressed(sender: UIButton) {
        let recording = RecordingViewController()
        self.navigationController?.pushViewController(recording, animated: true)
    }
    
    func trelloOAuthSend(sender: UIButton!) {

    }
    
    func logOutOfTrello() {
        let alert = UIAlertController(title: "Trello Log Out", message: "Do you want to log out of Trello?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: {action in
            //self._trelloAccount.removeTrello()
            
            (self.view as! StartView).createTrelloLoginButton()
            
            
            self.updateInstructionsAndRecord()
            self.infoLoaded = false
        })
        let noAction = UIAlertAction(title: "No", style: .Default, handler: {action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    func updateInstructionsAndRecord() {
    }

}
