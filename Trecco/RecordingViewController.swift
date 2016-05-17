//
//  RecordingViewController.swift
//  Trecco
//
//  Created by Joshua Johanan on 4/3/16.
//  Copyright © 2016 Joshua Johanan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, RecordViewProtocol {
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var timer: NSTimer?
    var recodingTime: Int = 0
    var fileURL: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Recording"
        
        self.view = RecordView()
        (self.view as! RecordView).delegate = self
        
        
        //setup the recording part
        let avSession: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try avSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try avSession.setActive(true)
        }catch {
            HandleError.ShowError("We were not able to setup recording.", error: error, viewController: self)
        }
        
        let docsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        fileURL = docsURL.URLByAppendingPathComponent("recording.wav")
        //settings for recording
        let settings: [String : AnyObject] = [
            AVFormatIDKey:Int(kAudioFormatLinearPCM),
            AVSampleRateKey:16000.0,
            AVNumberOfChannelsKey:1,
            AVEncoderAudioQualityKey:AVAudioQuality.High.rawValue
        ]
        
        do {
            try self.audioRecorder = AVAudioRecorder(URL: self.fileURL!, settings: settings)
            try avSession.setActive(true)
        }
        catch {
            HandleError.ShowError("We were not able to setup recording.", error: error, viewController: self)
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "checkRecordingTime", userInfo: nil, repeats: true)
        self.recodingTime = 15
        (self.view as! RecordView).setRecordingTime(String(self.recodingTime))
        self.audioRecorder?.prepareToRecord()
        self.audioRecorder?.record()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.audioRecorder?.stop()
        self.timer?.invalidate()
    }
    
    func checkRecordingTime() {
        self.recodingTime--
        (self.view as! RecordView).setRecordingTime(String(self.recodingTime))
        if recodingTime <= 0 {
            self.audioRecorder?.stop()
            self.stopRecording()
            self.timer?.invalidate()
        }
    }
    
    func stopRecording() {
        let process = ProcessRecordingViewController()
        process.http = HTTP()
        process.fileURL = self.fileURL
        self.navigationController?.pushViewController(process, animated: true)
    }
    
    func stopRecordingEarly(sender: UIButton) {
        self.audioRecorder?.stop()
        self.stopRecording()
        self.timer?.invalidate()
    }

}
