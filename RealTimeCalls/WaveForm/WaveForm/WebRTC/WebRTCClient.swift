//
//  WebRTCClient.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 11.04.23.
//

import Foundation
import WebRTC
import ReplayKit

public protocol WebRTCClientOutputProtocol: NSObject {
    func didGenerateCandidate(iceCandidate: RTCIceCandidate)
    func didClientChecking()
    func didClientConnected(statusChanged: @escaping () -> Void)
    func didDisconnect()
    func setRemoteView(view: UIView)
    func setLocalView(view: UIView)
}

public final class WebRTCClient: NSObject {
    private var peerConnectionFactory: RTCPeerConnectionFactory!
    private var peerConnection: RTCPeerConnection?
    private var localAudioTrack: RTCAudioTrack!
    private var localVideoTrack: RTCVideoTrack!
    private var videoCapturer: RTCVideoCapturer!
    private var localRenderView: RTCEAGLVideoView!
    private var remoteRenderView: RTCEAGLVideoView!
    private var remoteVideoTrack: RTCVideoTrack!
    
    private var rtcAudioSession = RTCAudioSession.sharedInstance()
    
    deinit {
        peerConnectionFactory = nil
        peerConnection = nil
    }

    weak var delegate: WebRTCClientOutputProtocol?
    
    func mute(isOn: Bool) {
        localAudioTrack.isEnabled = !isOn
    }
    
    func setSpeakerStates(enabled: Bool) {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSession.Category.playAndRecord)
        try? session.setMode(AVAudioSession.Mode.voiceChat)
        if enabled {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } else {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        }
        try? session.setActive(true)
    }
    
    func setRemoteVideoNeeded(needed: Bool) {
        if needed {
            remoteVideoTrack.add(remoteRenderView)
        } else {
            remoteVideoTrack.remove(remoteRenderView)
        }
    }
    
    func setLocalVideoState(isOn: Bool, cameraPosition: AVCaptureDevice.Position, completion: @escaping () -> Void) {
        localVideoTrack.isEnabled = true
        if isOn {
            localVideoTrack.add(localRenderView)
        } else {
            localVideoTrack.remove(localRenderView)
        }
        captureLocalVideo(cameraPositon: cameraPosition, isOn: isOn, completion: completion)
    }
    
    func setup() {
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        
        peerConnectionFactory = RTCPeerConnectionFactory(
            encoderFactory: videoEncoderFactory,
            decoderFactory: videoDecoderFactory
        )
        localAudioTrack = createAudioTrack()
        localVideoTrack = createVideoTrack()
        setAudioSessionState(isEnabled: false)
        localAudioTrack.isEnabled = false
        localVideoTrack.isEnabled = false
        
        setupRenderViews()
    }
    
    func connect(onSuccess: @escaping (RTCSessionDescription) -> Void){
        initializaPeerConnection()
        makeOffer(onSuccess: onSuccess)
    }
    
    func receiveOffer(offerSDP: RTCSessionDescription, onCreateAnswer: @escaping (RTCSessionDescription) -> Void){
        if peerConnection == nil {
            print("offer received, create peerconnection")
            initializaPeerConnection()
        }
        
        peerConnection!.setRemoteDescription(offerSDP) { (err) in
            if let error = err {
                print("failed to set remote offer SDP")
                print(error)
                return
            }
            
            print("succeed to set remote offer SDP")
            self.makeAnswer(onCreateAnswer: onCreateAnswer)
        }
    }
    
    func receiveAnswer(answerSDP: RTCSessionDescription) {
        peerConnection!.setRemoteDescription(answerSDP) { (err) in
            if let error = err {
                print("failed to set remote answer SDP")
                print(error)
                return
            }
        }
    }
    
    func receiveCandidate(candidate: RTCIceCandidate) {
        peerConnection!.add(candidate)
    }
    
    func receiveDisconnect() {
        disconnect()
    }
    
    private func initializaPeerConnection() {
        peerConnection = setupPeerConnection()
        peerConnection!.delegate = self
        
        peerConnection?.add(localAudioTrack, streamIds: ["stream0"])
        peerConnection?.add(localVideoTrack, streamIds: ["stream0"])
        remoteVideoTrack = peerConnection?.transceivers.first { $0.mediaType == .video }?.receiver.track as? RTCVideoTrack
    }
    
    private func createAudioTrack() -> RTCAudioTrack {
        let audioConstraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        let audioSource = peerConnectionFactory.audioSource(with: audioConstraints)
        let audioTrack = peerConnectionFactory.audioTrack(with: audioSource, trackId: "audio0")
        
        audioTrack.source.volume = 10
        return audioTrack
    }
    
    private func createVideoTrack() -> RTCVideoTrack {
        let videoSource = peerConnectionFactory.videoSource()

        if TARGET_OS_SIMULATOR != 0 {
            print("now runnnig on simulator...")
            videoCapturer = RTCFileVideoCapturer(delegate: videoSource)
        } else {
            videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)
        }
        
        let videoTrack = peerConnectionFactory.videoTrack(with: videoSource, trackId: "video0")
        return videoTrack
    }
    
    private func setupRenderViews() {
        localRenderView = RTCEAGLVideoView()
        localRenderView!.delegate = self
        remoteRenderView = RTCEAGLVideoView()
        remoteRenderView?.delegate = self
    }
    
    private func setupPeerConnection() -> RTCPeerConnection {
        let rtcConf = RTCConfiguration()
        rtcConf.sdpSemantics = RTCSdpSemantics.unifiedPlan
        rtcConf.iceServers = [
            RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"]),
            RTCIceServer(
                urlStrings: ["turn:relay1.expressturn.com:3478"],
                username: "ef3A2NVZP9LYWOE1DA",
                credential: "Em6MLhImGp09mUhi"
            )
//            RTCIceServer(
//                urlStrings: ["turn:34.125.10.47:3478"],
//                username: "kovich",
//                credential: "kovich123"
//            )
        ]
        let mediaConstraints = RTCMediaConstraints.init(mandatoryConstraints: nil, optionalConstraints: nil)
        let pc = self.peerConnectionFactory.peerConnection(with: rtcConf, constraints: mediaConstraints, delegate: nil)
        return pc
    }
    
    private func makeOffer(onSuccess: @escaping (RTCSessionDescription) -> Void) {
        peerConnection?.offer(for: RTCMediaConstraints(
            mandatoryConstraints: nil,
            optionalConstraints: nil)
        ) { (sdp, err) in
            if let error = err {
                print("error with make offer")
                print(error)
                return
            }
            
            if let offerSDP = sdp {
                print("make offer, created local sdp")
                self.peerConnection!.setLocalDescription(offerSDP) { (err) in
                    if let error = err {
                        print("error with set local offer sdp")
                        print(error)
                        return
                    }
                    print("succeed to set local offer SDP")
                    onSuccess(offerSDP)
                }
            }
        }
    }
    
    private func makeAnswer(onCreateAnswer: @escaping (RTCSessionDescription) -> Void) {
        peerConnection!.answer(for: RTCMediaConstraints(
            mandatoryConstraints: nil,
            optionalConstraints: nil)
        ) { (answerSessionDescription, err) in
            if let error = err {
                print("failed to create local answer SDP")
                print(error)
                return
            }
        
            print("succeed to create local answer SDP")
            if let answerSDP = answerSessionDescription {
                self.peerConnection!.setLocalDescription(answerSDP) { (err) in
                    if let error = err {
                        print("failed to set local ansewr SDP")
                        print(error)
                        return
                    }
                    
                    print("succeed to set local answer SDP")
                    onCreateAnswer(answerSDP)
                }
            }
        }
    }
    
    private func disconnect() {
        peerConnection?.close()
        setAudioSessionState(isEnabled: false)
        localAudioTrack.isEnabled = false
        localVideoTrack.isEnabled = false
        captureLocalVideo(cameraPositon: .back, isOn: false, completion: {})
    }
    
    private func captureLocalVideo(cameraPositon: AVCaptureDevice.Position, isOn: Bool, completion: @escaping () -> Void) {
        if let capturer = self.videoCapturer as? RTCCameraVideoCapturer {
            var targetDevice: AVCaptureDevice?
            var targetFormat: AVCaptureDevice.Format?
            
            let devicies = RTCCameraVideoCapturer.captureDevices()
            devicies.forEach { (device) in
                if device.position == cameraPositon{
                    targetDevice = device
                }
            }
            
            let formats = RTCCameraVideoCapturer.supportedFormats(for: targetDevice!)
            formats.forEach { (format) in
                for _ in format.videoSupportedFrameRateRanges {
                    let description = format.formatDescription as CMFormatDescription
                    let dimensions = CMVideoFormatDescriptionGetDimensions(description)
                    
                    targetFormat = format
                }
            }
            
            if isOn {
                capturer.startCapture(
                    with: targetDevice!,
                    format: targetFormat!,
                    fps: 60
                )
                completion()
            } else {
                capturer.stopCapture()
            }
        }
    }
    
    private func setAudioSessionState(isEnabled: Bool) {
        rtcAudioSession.lockForConfiguration()
        do {
            try rtcAudioSession.setActive(isEnabled)
        } catch let error {
            debugPrint("Couldn't force audio to speaker: \(error)")
        }
        rtcAudioSession.unlockForConfiguration()
    }
}

// MARK: - RTCPeerConnectionDelegate

extension WebRTCClient: RTCPeerConnectionDelegate {
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}
    
    public func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        switch newState {
        case .closed:
            print("closed")
            self.peerConnection = nil
            DispatchQueue.main.async {
                self.delegate?.didDisconnect()
                self.setAudioSessionState(isEnabled: false)
            }
        case .checking:
            print("checking")
            DispatchQueue.main.async {
                self.delegate?.didClientChecking()
                self.delegate?.setRemoteView(view: self.remoteRenderView)
                self.delegate?.setLocalView(view: self.localRenderView)
            }
        case .completed:
            print("completed")
        case .connected:
            print("connected")
            DispatchQueue.main.async {
                self.delegate?.didClientConnected(
                    statusChanged: {
                        self.setAudioSessionState(isEnabled: true)
                        self.localAudioTrack.isEnabled = true
                    }
                )
            }
        case .count:
            print("count")
        case .disconnected:
            print("disconnected")
            self.setAudioSessionState(isEnabled: false)
        case .failed:
            print("failed")
        case .new:
            print("new")
        }
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        DispatchQueue.main.async {
            self.delegate?.didGenerateCandidate(iceCandidate: candidate)
        }
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) { }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) { }
}

// MARK: - RTCVideoViewDelegate

extension WebRTCClient: RTCVideoViewDelegate {
    public func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
//        let isLandScape = size.width < size.height
//        var renderView: RTCEAGLVideoView?
//        var parentView: UIView?
//        if videoView.isEqual(localRenderView){
//            print("local video size changed")
//            renderView = localRenderView
//            parentView = localView
//        }
//
//        if videoView.isEqual(remoteRenderView!){
//            print("remote video size changed to: ", size)
//            renderView = remoteRenderView
//            parentView = remoteView
//        }
//
//        guard let _renderView = renderView, let _parentView = parentView else {
//            return
//        }
//
//        if(isLandScape){
//            let ratio = size.width / size.height
//            _renderView.frame = CGRect(x: 0, y: 0, width: _parentView.frame.height * ratio, height: _parentView.frame.height)
//            _renderView.center.x = _parentView.frame.width/2
//        }else{
//            let ratio = size.height / size.width
//            _renderView.frame = CGRect(x: 0, y: 0, width: _parentView.frame.width, height: _parentView.frame.width * ratio)
//            _renderView.center.y = _parentView.frame.height/2
//        }
    }
}
