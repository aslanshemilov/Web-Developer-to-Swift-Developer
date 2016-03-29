//
//  MainViewController.swift
//  Trecco
//
//  Created by Joshua Johanan on 3/26/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {

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
    
    func updateInstructionsAndRecord() {
    }

}
