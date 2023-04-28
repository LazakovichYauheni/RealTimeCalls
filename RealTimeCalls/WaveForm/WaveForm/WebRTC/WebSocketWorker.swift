//
//  WebSocketWorker.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 11.04.23.
//

import Foundation
import Starscream
import WebRTC

public protocol WebSocketWorkerOutputProtocol: AnyObject {
    func didNeedToShowNotification()
    func didClientChecking()
    func didClientConnected(statusChanged: @escaping () -> Void)
    func didDisconnect()
    func needToShowRemoteVideo()
    func needToShowLocalVideo()
    func needToHideRemoteVideo()
    func needToHideLocalVideo()
    func needToFlip()
    func setRemoteView(videoView: UIView)
    func setLocalView(videoView: UIView)
}

public final class WebSocketWorker: NSObject {
    // MARK: - Public Properties
    
    weak var delegate: WebSocketWorkerOutputProtocol?
    
    // MARK: - Private Properties
    
    private let localWebSocketAddress = "192.168.0.103"
    private let socketHostAddress = "wss://signaling-server-0rug.onrender.com"
    private let socket: WebSocket
    private let cameraSession = CameraSession()
    private let webRTCClient = WebRTCClient()
    private var tryToConnectWebSocket: Timer!
    
    // MARK: - Init
    
    public override init() {
        //socket = WebSocket(url: URL(string: socketHostAddress)!)
        socket = WebSocket(url: URL(string: "ws://" + localWebSocketAddress + ":8080/")!)
        
        webRTCClient.setup()
        super.init()
        webRTCClient.delegate = self
        cameraSession.delegate = self
        socket.delegate = self
        
        tryToConnectWebSocket = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            if self.socket.isConnected {
                return
            }

            self.socket.connect()
        })
    }
    
    // MARK: - Public Methods
    
    func sendNotification() {
        sendSocketMessage(with: "notification")
    }
    
    func sendTapNotification() {
        sendSocketMessage(with: "notificationTapped")
    }
    
    func mute(isOn: Bool) {
        webRTCClient.mute(isOn: isOn)
    }
    
    func setSpeakerState(isOn: Bool) {
        webRTCClient.setSpeakerStates(enabled: isOn)
    }
    
    func setLocalVideoState(
        isOn: Bool,
        cameraPosition: AVCaptureDevice.Position,
        needToAppearLocalVideoScreen: Bool,
        isJustFlipping: Bool
    ) {
        
        if !isJustFlipping {
            sendSocketMessage(with: "videoHide")
        }
        DispatchQueue.global(qos: .background).async {
            if isOn {
                self.cameraSession.setupSession()
            } else {
                self.cameraSession.stopSession()
            }
            
            DispatchQueue.main.async {
                self.webRTCClient.setLocalVideoState(isOn: isOn, cameraPosition: cameraPosition) {}
                if isOn && needToAppearLocalVideoScreen {
                    self.delegate?.needToShowLocalVideo()
                } else if !isOn {
                    self.delegate?.needToHideLocalVideo()
                } else if isJustFlipping {
                    self.delegate?.needToFlip()
                }
            }
        }
    }
    
    func sendLocalVideo() {
        sendSocketMessage(with: "videoShow")
    }
    
    func disconnect() {
        sendSocketMessage(with: "disconnect")
    }
    
    private func call() {
        webRTCClient.connect(onSuccess: { (offerSDP: RTCSessionDescription) -> Void in
            self.sendSDP(sessionDescription: offerSDP)
        })
    }
    
    private func sendSocketMessage(with type: String) {
        let signalingMessage = SignalingMessage.init(type: type, sessionDescription: nil, candidate: nil)
        let data = try! JSONEncoder().encode(signalingMessage)
        let message = String(data: data, encoding: String.Encoding.utf8)!
        self.socket.write(string: message)
    }
    
    private func sendSDP(sessionDescription: RTCSessionDescription) {
        var type = ""
        if sessionDescription.type == .offer {
            type = "offer"
        } else if sessionDescription.type == .answer {
            type = "answer"
        }

        let sdp = SDP.init(sdp: sessionDescription.sdp)
        let signalingMessage = SignalingMessage.init(type: type, sessionDescription: sdp, candidate: nil)
        do {
            let data = try JSONEncoder().encode(signalingMessage)
            let message = String(data: data, encoding: String.Encoding.utf8)!

            if self.socket.isConnected {
                self.socket.write(string: message)
            }
        }catch{
            print(error)
        }
    }
    
    private func sendCandidate(iceCandidate: RTCIceCandidate){
        let candidate = Candidate.init(sdp: iceCandidate.sdp, sdpMLineIndex: iceCandidate.sdpMLineIndex, sdpMid: iceCandidate.sdpMid!)
        let signalingMessage = SignalingMessage.init(type: "candidate", sessionDescription: nil, candidate: candidate)
        do {
            let data = try JSONEncoder().encode(signalingMessage)
            let message = String(data: data, encoding: String.Encoding.utf8)!

            if self.socket.isConnected {
                self.socket.write(string: message)
            }
        }catch{
            print(error)
        }
    }
}

// MARK: - WebSocketDelegate

extension WebSocketWorker: WebSocketDelegate {
    public func websocketDidConnect(socket: Starscream.WebSocketClient) {
        print("socket connected")
    }
    
    public func websocketDidDisconnect(socket: Starscream.WebSocketClient, error: Error?) {}
    
    public func websocketDidReceiveMessage(socket: Starscream.WebSocketClient, text: String) {
        do {
            let signalingMessage = try JSONDecoder().decode(SignalingMessage.self, from: text.data(using: .utf8)!)
            
            switch signalingMessage.type {
            case "notification":
                delegate?.didNeedToShowNotification()
            case "notificationTapped":
                call()
            case "offer":
                webRTCClient.receiveOffer(
                    offerSDP: RTCSessionDescription(
                        type: .offer,
                        sdp: (signalingMessage.sessionDescription?.sdp)!
                    ),
                    onCreateAnswer: { answerSDP -> Void in
                        self.sendSDP(sessionDescription: answerSDP)
                    }
                )
            case "answer":
                webRTCClient.receiveAnswer(
                    answerSDP: RTCSessionDescription(
                        type: .answer,
                        sdp: (signalingMessage.sessionDescription?.sdp)!
                    )
                )
            case "candidate":
                let candidate = signalingMessage.candidate!
                webRTCClient.receiveCandidate(
                    candidate: RTCIceCandidate(
                        sdp: candidate.sdp,
                        sdpMLineIndex: candidate.sdpMLineIndex,
                        sdpMid: candidate.sdpMid
                    )
                )
            case "disconnect":
                webRTCClient.receiveDisconnect()
            case "videoShow":
                delegate?.needToShowRemoteVideo()
                webRTCClient.setRemoteVideoNeeded(needed: true)
            case "videoHide":
                delegate?.needToHideRemoteVideo()
                webRTCClient.setRemoteVideoNeeded(needed: false)
            default:
                return
            }
        } catch {
            print(error)
        }
    }
    
    public func websocketDidReceiveData(socket: Starscream.WebSocketClient, data: Data) {}
}

// MARK: - WebRTCClientOutputProtocol

extension WebSocketWorker: WebRTCClientOutputProtocol {
    public func didGenerateCandidate(iceCandidate: RTCIceCandidate) {
        sendCandidate(iceCandidate: iceCandidate)
    }
    
    public func didClientChecking() {
        delegate?.didClientChecking()
    }
    
    public func didClientConnected(statusChanged: @escaping () -> Void) {
        delegate?.didClientConnected(statusChanged: statusChanged)
    }
    
    public func setRemoteView(view: UIView) {
        delegate?.setRemoteView(videoView: view)
    }
    
    public func setLocalView(view: UIView) {
        delegate?.setLocalView(videoView: view)
    }
    
    public func didDisconnect() {
        delegate?.didDisconnect()
    }
}

extension WebSocketWorker: CameraSessionDelegate {
    func didOutput(_ sampleBuffer: CMSampleBuffer) {
//        if let cvpixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
//            webRTCClient.captureCurrentFrame(sampleBuffer: cvpixelBuffer)
//        }
//        print(sampleBuffer)
    }
}
