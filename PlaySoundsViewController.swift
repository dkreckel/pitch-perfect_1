//
//  PlaySoundsViewController.swift
//  Pitch Perfect 2
//
//  Created by Darrell Kreckel on 5/17/15.
//  Copyright (c) 2015 Darrell Kreckel. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){

        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    // This funtion stops all audio
    func stopAllAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    //Stop all playing
    @IBAction func stopPlaying(sender: UIButton) {
        println("stop playing")
        stopAllAudio()
    }
    
    //Play audio really fast here.....
    @IBAction func playFast(sender: UIButton) {
        playAudioWithVarialbeRate(2.0)
    }
    
    //Play audio slooowly here.....
    @IBAction func playSlow(sender: UIButton) {
        playAudioWithVarialbeRate(0.5)
    }

    //Play the audio with the rate of the calling function
    func playAudioWithVarialbeRate(rate: Float){
        stopAllAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

}