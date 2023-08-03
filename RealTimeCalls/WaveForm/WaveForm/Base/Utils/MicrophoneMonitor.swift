//
//  Microphone.swift
//

import Foundation
import AVFoundation

protocol MicrophoneEventsDelegate: AnyObject {
    func didLevelChanged(value: CGFloat)
}

class MicrophoneMonitor: ObservableObject {
    
    weak var delegate: MicrophoneEventsDelegate?
    
    private var audioRecorder: AVAudioRecorder
    private var timer: Timer?
    
    let audioSession = AVAudioSession.sharedInstance()
    
    init() {
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted { fatalError("You must allow audio recording for this demo to work") }
            }
        }
        
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            
            startMonitoring()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func startMonitoring() {
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            self.audioRecorder.updateMeters()
            let power = self.audioRecorder.averagePower(forChannel: .zero)
            
            let normalizedPower = self.normalizeSoundLevel(level: power)
            
            self.delegate?.didLevelChanged(value: normalizedPower)
        })
    }
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let positiveLevel = Int(level + 47) + 200
        return CGFloat(positiveLevel)
    }
    
    deinit {
        timer?.invalidate()
        audioRecorder.stop()
    }
}

