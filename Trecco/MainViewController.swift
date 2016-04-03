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
    
    func createWarningAttributedString(trelloConnected: Bool, recordPermission: Bool) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        //set up center paragraph style
        let centerPStyle = NSMutableParagraphStyle()
        centerPStyle.alignment = .Center
        centerPStyle.lineBreakMode = .ByWordWrapping
        
        if (!trelloConnected){
            attributedString.appendAttributedString(NSAttributedString(string: "Please connect to Trello\n",
                attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(16), NSParagraphStyleAttributeName: centerPStyle]))
            
            attributedString.appendAttributedString(NSAttributedString(string: "You will be able to sync your voice note to a Trello Board\n",
                attributes: [NSFontAttributeName: UIFont.systemFontOfSize(10), NSParagraphStyleAttributeName: centerPStyle]))
        }
        
        if(!recordPermission) {
            attributedString.appendAttributedString(NSAttributedString(string: "Please allow Access to the Microphone\n",
                attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(16), NSParagraphStyleAttributeName: centerPStyle]))
            
            attributedString.appendAttributedString(NSAttributedString(string: "You will be able to create voice notes. After recording the note, it will be sent to IBM's Watson to be transcribed.\n", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(10), NSParagraphStyleAttributeName: centerPStyle]))
        }
        
        
        return attributedString
    }

    
    func updateInstructionsAndRecord() {
        let avSession: AVAudioSession = AVAudioSession.sharedInstance()
        let recordPermission: Bool = avSession.recordPermission() == AVAudioSessionRecordPermission.Granted
        let trelloConnected: Bool = false
        
        self.setInstructions(trelloConnected, recordPermission: recordPermission)
    }
    
    func setInstructions(trelloConnected: Bool, recordPermission: Bool) {
        let attributedString = self.createWarningAttributedString(trelloConnected, recordPermission: recordPermission)
        (self.view as! StartView).updateInstructions(attributedString)
    }

}
