//
//  CameraSession.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 15.04.23.
//

import Foundation
import AVFoundation

protocol CameraSessionDelegate: AnyObject {
    func didOutput(_ sampleBuffer: CMSampleBuffer)
}
final class CameraSession: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var session: AVCaptureSession?
    private var output: AVCaptureVideoDataOutput?
    private var device: AVCaptureDevice?
    weak var delegate: CameraSessionDelegate?
    
    override init() {
        super.init()
    }
    
    func setupSession(){
        self.session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSession.Preset.medium
        self.device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        guard
            let device = self.device,
            let input = try? AVCaptureDeviceInput(device: device) else {
            print("Caught exception!")
            return
        }
        
        self.session?.addInput(input)
        
        self.output = AVCaptureVideoDataOutput()
        let queue: DispatchQueue = DispatchQueue(label: "videodata", attributes: .concurrent)
        self.output?.setSampleBufferDelegate(self, queue: queue)
        self.output?.alwaysDiscardsLateVideoFrames = false
        self.output?.videoSettings = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] as [String : Any]
        self.session?.addOutput(self.output!)
        
        self.session?.sessionPreset = AVCaptureSession.Preset.inputPriority
        self.session?.usesApplicationAudioSession = false
        
        self.session?.startRunning()
    }
    
    func stopSession() {
        self.session?.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.delegate?.didOutput(sampleBuffer)
    }
}
