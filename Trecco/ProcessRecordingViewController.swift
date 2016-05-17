//
//  ProcessRecordingViewController.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/11/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit
import BrightFutures

class ProcessRecordingViewController: UIViewController, UITextViewDelegate, ProcessViewProtocol {
    var api: TrelloAPI!
    var http: HTTPActions!
    var pickerSource: TrelloBoardPickerSource!
    
    var processedFile = false
    var trelloConnected = false
    var fileURL: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        self.title = "Watson is listening"
        
        self.view = ProcessView()
        (self.view as! ProcessView).delegate = self
        
        (self.view as! ProcessView).textViewOutput.delegate = self
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelProcessing:")
        self.navigationItem.rightBarButtonItem = cancelButton
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if (!self.processedFile)
        {
            //process file
            let mainBundle = NSBundle.mainBundle()
            let usernameOp = mainBundle.objectForInfoDictionaryKey(GlobalConstants.WATSON_USERNAME) as? String
            let passwordOp = mainBundle.objectForInfoDictionaryKey(GlobalConstants.WATSON_PASSWORD) as? String
            
            guard let username = usernameOp else {
                HandleError.ShowAlert("Cannot connect to Watson", viewController: self)
                return}
            guard let password = passwordOp else {
                HandleError.ShowAlert("Cannot connect to Watson", viewController: self)
                return}
            
            let watson = WatsonSTT(username: username, password: password, http: self.http)
            
            guard let fileURL = self.fileURL else {
                HandleError.ShowAlert("Cannot process recording", viewController: self)
                return
            }
            
            watson.processFileURL(fileURL).onSuccess{results in
                guard let result = results else {
                    (self.view as! ProcessView).textViewOutput.text = ""
                    self.title = "Watson did not hear anything"
                    return
                }
                
                (self.view as! ProcessView).textViewOutput.text = result.transcript
                self.textViewDidChange((self.view as! ProcessView).textViewOutput)
                if (result.transcript.isEmpty) {
                    self.title = "Watson did not hear anything"
                }else {
                    self.title = "Watson Heard:"
                }
                
                }.onFailure{error in
                    HandleError.ShowError("Watson errored when processing the recording.", error: error, viewController: self)
            }
            
            //get boards
            let _trelloAccount = TrelloAccount(defaultObject: NSUserDefaults.standardUserDefaults())
            if(_trelloAccount.isTrelloConnected()){
                self.trelloConnected = true
                let keyOp = NSBundle.mainBundle().objectForInfoDictionaryKey(GlobalConstants.TRELLO_API_KEY) as? String
                let tokenOp = _trelloAccount.getTrelloAccountToken()
                
                guard let key = keyOp else {
                    HandleError.ShowAlert("Could not connect to Trello", viewController: self)
                    return
                }
                
                guard let token = tokenOp else {
                    HandleError.ShowAlert("Could not connect to Trello", viewController: self)
                    return
                }
                
                self.api = TrelloAPI(key: key, token: token, http: self.http)
                
                api.getAllListsForAllBoards()
                    .onSuccess{boards in
                        self.pickerSource = TrelloBoardPickerSource(boards: boards)
                        (self.view as! ProcessView).boardPicker.dataSource = self.pickerSource
                        (self.view as! ProcessView).boardPicker.delegate = self.pickerSource
                    }
                    .onFailure{error in HandleError.ShowError("Could not get your Trello boards.", error: error, viewController: self)}
            }
            
            self.processedFile = true
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        self.updatePostToTrelloButton(self.shouldButtonBeEnabled(textView.text, trelloConnected: self.trelloConnected))
    }
    
    func updatePostToTrelloButton(enabled: Bool) {
        (self.view as! ProcessView).buttonPostToTrello.enabled = enabled
    }
    
    func shouldButtonBeEnabled(textViewText: String, trelloConnected: Bool) -> Bool
    {
        return !textViewText.isEmpty && trelloConnected
    }
    
    func cancelProcessing(sender: UIBarButtonItem!) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func postToTrelloPressed(sender: UIButton) {
        self.postToTrello()
    }
    
    func postToTrello() {
        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        self.title = "Posting to Trello"
        
        let card = TrelloCreateCard(idList: self.pickerSource.getList((self.view as! ProcessView).boardPicker.selectedRowInComponent(0),
            listRow: (self.view as! ProcessView).boardPicker.selectedRowInComponent(1)),
            name: (self.view as! ProcessView).textViewOutput.text)
        
        self.api.createCard(card)
            .onSuccess{card in
                self.title = "Card Posted"
                let cancelButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "cancelProcessing:")
                self.navigationItem.rightBarButtonItem = cancelButton
                self.showTrelloCard(card.id, trelloURL: card.shortUrl)
            }
            .onFailure{error in
                HandleError.ShowError("Error posting the card.", error: error, viewController: self)
        }
        
    }
    
    func showTrelloCard(trelloId: String, trelloURL: String) {
        let hasTrello = UIApplication.sharedApplication().canOpenURL(NSURL(string:"trello://x-callback-url/showCard?x-source=Trecco")!)
        let alert = self.createTrelloCardAlert(trelloId, trelloURL: trelloURL, canOpen: hasTrello)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createTrelloCardAlert(trelloId: String, trelloURL: String, canOpen: Bool) -> UIAlertController {
        let alert = UIAlertController(title: "Trello Card Created", message: "View your Trello card", preferredStyle: .Alert)
        let appAction = UIAlertAction(title: "View in Trello App", style: .Default, handler: {action in
            let url = NSURL(string: "trello://x-callback-url/showCard?x-source=Trecco&id=\(trelloId)")
            self.navigationController?.popToRootViewControllerAnimated(false)
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().openURL(url!)
            }
        })
        
        let browserAction = UIAlertAction(title: "View in Browser", style: .Default, handler: {action in
            let url = NSURL(string: trelloURL)
            self.navigationController?.popToRootViewControllerAnimated(false)
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().openURL(url!)
            }
        })
        
        let doneAction = UIAlertAction(title: "I am done", style: .Default, handler: {action in
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        
        if (canOpen) {
            alert.addAction(appAction)
        }
        
        alert.addAction(browserAction)
        alert.addAction(doneAction)
        
        return alert
    }

}
