//
//  RecordSoundsViewController.swift
//  Pitch Perfect 2
//
//  Created by Darrell Kreckel on 5/10/15.
//  Copyright (c) 2015 Darrell Kreckel. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    //Delcared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    

    @IBOutlet weak var recordingInProgress: UILabel!

    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        //CALL the corresponding Super method (super.viewDidAppear(animated))
        super.viewDidAppear(animated)
        stopButton.hidden = true
        recordingInProgress.text = "Tap to Record"
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.text = "Tap to Record"
        stopButton.hidden = true;
        recordButton.enabled = true;
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
        
        println("Stopped Recording")
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.text = "Recording"
        errorMessage.text = " "
        stopButton.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        //Record User's Voice
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Initialize and Prepare the Recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        println("in RecordAudio")
    }
    

    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //Step 1 - Save the recorded audio
            
            var recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            //Step 2 - Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            errorMessage.text = "Recording was successful!"
            
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            errorMessage.text = "Recording was not successful"
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

