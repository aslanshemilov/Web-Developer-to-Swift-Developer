//
//  MainViewController.swift
//  Trecco
//
//  Created by Joshua Johanan on 3/26/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit
import AVFoundation

//for TrelloAccount
extension NSUserDefaults: UserDefaultsProtocol {}

class MainViewController: UIViewController, StartViewProtocol {
    var infoLoaded: Bool = false
    var _trelloAccount: TrelloAccount!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Trecco"
        self.view = StartView()
        (self.view as! StartView).delegate = self
        
        //create trelloAccount
        _trelloAccount = TrelloAccount(defaultObject: NSUserDefaults.standardUserDefaults())
        
        //ask for record permission
        let avSession: AVAudioSession = AVAudioSession.sharedInstance()
        if(avSession.respondsToSelector("requestRecordPermission:")){
            avSession.requestRecordPermission({(granted: Bool) -> Void in self.updateInstructionsAndRecord()})
        }
        
        //setup Trello auth Finish
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "trelloAuthFinish:", name: GlobalConstants.TRELLO_AUTH_FINISH, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "trelloLoadInfo:", name: GlobalConstants.TRELLO_LOAD_INFO, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        //check if we are authenticated
        let trelloConnected: Bool = (_trelloAccount.isTrelloConnected())
        
        updateInstructionsAndRecord()
        
        if(!trelloConnected) {
            (self.view as! StartView).createTrelloLoginButton()
        }else{
            //if authenticated say we are
            NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.TRELLO_AUTH_FINISH, object: nil)
        }
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
    
    // MARK: Trello Authentication
    
    func trelloAuthFinish(notification: NSNotification) {
        //check if we have your info
        
        if(_trelloAccount.isTrelloConnected() == true && _trelloAccount.getTrelloName() != nil) {
            NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.TRELLO_LOAD_INFO, object: nil)
            return
        }
        
        
        let keyOptional = NSBundle.mainBundle().objectForInfoDictionaryKey(GlobalConstants.TRELLO_API_KEY) as? String
        let tokenOptional = _trelloAccount.getTrelloAccountToken()
        
        guard let key = keyOptional else {
            HandleError.ShowAlert("Could not connect to Trello", viewController: self)
            return
        }
        
        guard let token = tokenOptional else {
            HandleError.ShowAlert("Could not connect to Trello", viewController: self)
            return
        }
        
        let trelloAPI = TrelloAPI(key: key, token: token, http: HTTP())
        trelloAPI.getMe()
            .onSuccess{member in
                self._trelloAccount.setTrelloAvatarHash(member.avatarHash)
                self._trelloAccount.setTrelloName(member.fullName)
                NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.TRELLO_LOAD_INFO, object: nil)
            }.onFailure{error in
                HandleError.ShowError("Failed to get your Trello account info.", error: error, viewController: self)
        }
    }
    
    func trelloLoadInfo(notification: NSNotification) {
        if (infoLoaded) {
            return
        }
        
        createTrelloAuthenticatedView()
        updateInstructionsAndRecord()
    }

    
    func trelloOAuthSend(sender: UIButton!) {
        let mainBundle = NSBundle.mainBundle()
        let trelloKeyOp = mainBundle.objectForInfoDictionaryKey(GlobalConstants.TRELLO_API_KEY) as? String
        let trelloSecretOp = mainBundle.objectForInfoDictionaryKey(GlobalConstants.TRELLO_API_SECRET) as? String
        
        guard let trelloKey = trelloKeyOp else {HandleError.ShowAlert("Could not connect to Trello", viewController: self); return}
        
        guard let trelloSecret = trelloSecretOp else {HandleError.ShowAlert("Could not connect to Trello", viewController: self); return}
        
        let trelloAuth = TrelloOAuth(apiKey: trelloKey, apiSecret: trelloSecret)
        trelloAuth.authenticate(OauthViewController(),
            completionHandler: self.handleOAuthReturn)
    }
    
    func handleOAuthReturn(token: String?, error: ErrorType?) {
        if let error = error {
            if (shouldErrorFireAnAlert(error)){
                //one is just OAuth was denied
                HandleError.ShowError("Error when authorizing your Trello account.", error: error, viewController: self)
            }
            
        }
        
        if let token = token {
            self.didAuthenticate(token)
        }
    }
    
    func shouldErrorFireAnAlert(error: ErrorType) -> Bool {
        print((error as NSError))
        return (error as NSError).code != -1
    }
    
    func didAuthenticate(token: String) {
        _trelloAccount.setTrelloAccountToken(token)
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.TRELLO_AUTH_FINISH, object: nil)
    }
    
    func logOutOfTrello() {
        let alert = UIAlertController(title: "Trello Log Out", message: "Do you want to log out of Trello?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: {action in
            self._trelloAccount.removeTrello()
            
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
    
    func createTrelloAuthenticatedView() {
        let hashOp = _trelloAccount.getTrelloAvatarHashURL("https://trello-avatars.s3.amazonaws.com/")
        let nameOp = self._trelloAccount.getTrelloName()
        
        guard let hash = hashOp else {return}
        guard let name = nameOp else {return}
        
        let imageURLOp = NSURL(string: hash)
        
        guard let imageURL = imageURLOp else {return}
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
            let image_data = NSData(contentsOfURL: imageURL)
            
            dispatch_async(dispatch_get_main_queue()) {
                (self.view as! StartView).createTrelloAuthenticatedView(image_data, name: name)
            }
        }
        
        
        self.infoLoaded = true
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
        let trelloConnected: Bool = (_trelloAccount.isTrelloConnected())
        
        self.setInstructions(trelloConnected, recordPermission: recordPermission)
    }
    
    func setInstructions(trelloConnected: Bool, recordPermission: Bool) {
        let attributedString = self.createWarningAttributedString(trelloConnected, recordPermission: recordPermission)
        (self.view as! StartView).updateInstructions(attributedString)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
