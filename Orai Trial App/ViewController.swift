//
//  ViewController.swift
//  Orai Trial App
//
//  Created by Chris Thompson on 11/18/17.
//  Copyright © 2017 Chris Thompson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var soundSetting = [String : Int]()


    
    
    
    @IBOutlet weak var recordOutlet: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    
    
    
    
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        print(soundURL)
        return soundURL as NSURL?
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func startRecording() {

        let audioSession = AVAudioSession.sharedInstance()

        
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: soundSetting)
            print(audioRecorder.url)

            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            print("recording")
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
        
    }

    func finishRecording(success: Bool) {
        audioRecorder.stop()
        
        if success {
            recordOutlet.setTitle("Tap to Re-record", for: .normal)
            print("success")
        } else {
            recordOutlet.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
    @IBAction func recordAction(_ sender: Any) {
        

        
        if audioRecorder == nil {
            startRecording()
            if let image = UIImage(named: "icons8-stop-120.png") {
                self.playButton.isHidden = false

                self.recordOutlet.setImage(image, for: .normal)
                UIView.animate(withDuration: 2.0,
                               delay: 0,
                               usingSpringWithDamping: 0.2,
                               initialSpringVelocity: 6.0,
                               options: .allowUserInteraction,
                               animations: { [weak self] in
                                self?.recordOutlet.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)

                    },
                               completion: nil)
            }

        } else {
            finishRecording(success: true)
            if let image = UIImage(named: "icons8-microphone-250.png") {
                self.recordOutlet.setImage(image, for: .normal)
                self.playButton.isHidden = false
            }
            UIView.animate(withDuration: 2.0,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 6.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            self?.recordOutlet.transform = .identity

                },
                           completion: nil)
        }
    }
    
    
    @IBAction func playAction(_ sender: Any) {
        print(audioRecorder)
        
            self.audioPlayer = try! AVAudioPlayer(contentsOf: audioRecorder.url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
    
        
    }
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordOutlet.isHidden = false
                        self.recordOutlet.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

                        UIView.animate(withDuration: 2.0,
                                       delay: 0,
                                       usingSpringWithDamping: 0.2,
                                       initialSpringVelocity: 6.0,
                                       options: .allowUserInteraction,
                                       animations: { [weak self] in
                                        self?.recordOutlet.transform = .identity
                                        
                            },
                                       completion: nil)
                        

                        } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        soundSetting = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

