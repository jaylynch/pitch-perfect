//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jay Lynch on 17/02/2015.
//  Copyright (c) 2015 Jay Lynch. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var btnStopPlayback: UIButton!
    @IBOutlet weak var sldOverlap: UISlider!
    
    var engine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayerNode:AVAudioPlayerNode!
    var audioPlayerTimePitch:AVAudioUnitTimePitch!
    
    var receivedAudio = RecordedAudio()

    override func viewDidLoad() {
        super.viewDidLoad()
        engine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Plays back the recorded audio file, specifying the rate of playback and
    //  (optionally) adjusted pitch.
    //
    // speed:
    //      Adjusted playback rate (0.5x ~ 2.0x)
    //
    // pitch:
    //      Adjusted audio pitch in "cents" (-2,400 - 2,400)
    //      One musical semitone = 100 cents, one octave = 1200 cents
    
    func startPlayback(speed: Float, pitch: Float = 1.0) {
        engine.stop()
        engine.reset()
        
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayerNode = AVAudioPlayerNode()
        audioPlayerTimePitch = AVAudioUnitTimePitch()
        
        audioPlayerTimePitch.pitch = pitch
        audioPlayerTimePitch.rate = speed
        audioPlayerTimePitch.overlap = sldOverlap.value
        
        engine.attachNode(audioPlayerNode)
        engine.attachNode(audioPlayerTimePitch)

        engine.connect(audioPlayerNode, to: audioPlayerTimePitch, format: nil)
        engine.connect(audioPlayerTimePitch, to: engine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        engine.startAndReturnError(nil)
        
        btnStopPlayback.hidden = false
        audioPlayerNode.play()
    }
    
    @IBAction func playSlow(sender: UIButton) {
        startPlayback(0.5)
    }
    @IBAction func playFast(sender: UIButton) {        
        startPlayback(2.0)
    }
    @IBAction func playLow(sender: UIButton) {
        startPlayback(1, pitch: -1000)
    }
    @IBAction func playHigh(sender: UIButton) {
        startPlayback(1, pitch: 1000)
    }

    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayerNode.stop()
        btnStopPlayback.hidden = true
    }

}
