//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jay Lynch on 11/02/2015.
//  Copyright (c) 2015 Jay Lynch. All rights reserved.
//

import UIKit
import AVFoundation

var audioRecorder:AVAudioRecorder!
var recordedAudio:RecordedAudio!

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        lblRecordingStatus.text = "Tap to Record"
        btnStopRecording.hidden = true
        btnStartRecording.enabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var lblRecordingStatus: UILabel!
    @IBOutlet weak var btnStartRecording: UIButton!
    @IBOutlet weak var btnStopRecording: UIButton!
    
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        btnStopRecording.hidden = true
        lblRecordingStatus.text = "Tap to Record"
        btnStartRecording.enabled = true
    }

    // Commences recording audio, readying it to a file which can then
    //  be passed to a RecordedAudio model for sending to playback controller
    @IBAction func recordAudio(sender: UIButton) {
        btnStartRecording.enabled = false
        lblRecordingStatus.text = "Recording in progress..."
        btnStopRecording.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(path: recorder.url, title: recorder.url.lastPathComponent!)
            audioRecorder.stop()
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }

}

