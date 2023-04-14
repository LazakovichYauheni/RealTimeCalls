//
//  WebSocketWorker.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 11.04.23.
//

import Foundation
import Starscream
import WebRTC

public protocol WebSocketWorkerDelegate: AnyObject {
    func didNeedToShowNotification()
    func didClientChecking()
    func didClientConnected(statusChanged: @escaping () -> Void)
}

public final class WebSocketWorker: NSObject {
    // MARK: - Public Properties
    
    weak var delegate: WebSocketWorkerDelegate?
    
    // MARK: - Private Properties
    
    private let ipAddress = "192.168.0.103"
    private let socket: WebSocket
    private let webRTCClient = WebRTCClient()
    private var tryToConnectWebSocket: Timer!

    func call() {
        webRTCClient.connect(onSuccess: { (offerSDP: RTCSessionDescription) -> Void in
            self.sendSDP(sessionDescription: offerSDP)
        })
    }
    
    func sendNotification() {
        let signalingMessage = SignalingMessage.init(type: "notification", sessionDescription: nil, candidate: nil)
        let data = try! JSONEncoder().encode(signalingMessage)
        let message = String(data: data, encoding: String.Encoding.utf8)!
        self.socket.write(string: message)
    }
    
    func mute(isOn: Bool) {
        webRTCClient.mute(isOn: isOn)
    }
    
    func sendTapNotification() {
        let signalingMessage = SignalingMessage.init(type: "notificationTapped", sessionDescription: nil, candidate: nil)
        let data = try! JSONEncoder().encode(signalingMessage)
        let message = String(data: data, encoding: String.Encoding.utf8)!
        self.socket.write(string: message)
    }
    
    public override init() {
        socket = WebSocket(url: URL(string: "ws://" + ipAddress + ":8080/")!)
        
        webRTCClient.setup()
        super.init()
        webRTCClient.delegate = self
        socket.delegate = self
        
        tryToConnectWebSocket = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            if self.socket.isConnected {
                return
            }

            self.socket.connect()
        })
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

extension WebSocketWorker: WebSocketDelegate {
    public func websocketDidConnect(socket: Starscream.WebSocketClient) {
        print("socket connected")
    }
    
    public func websocketDidDisconnect(socket: Starscream.WebSocketClient, error: Error?) {
        print("socket disconnected")
    }
    
    public func websocketDidReceiveMessage(socket: Starscream.WebSocketClient, text: String) {
        print("message received")
        
        do {
            let signalingMessage = try JSONDecoder().decode(SignalingMessage.self, from: text.data(using: .utf8)!)
            
            if signalingMessage.type == "notification" {
                delegate?.didNeedToShowNotification()
            } else if signalingMessage.type == "notificationTapped" {
                call()
            } else if signalingMessage.type == "offer" {
                webRTCClient.receiveOffer(
                    offerSDP: RTCSessionDescription(
                        type: .offer,
                        sdp: (signalingMessage.sessionDescription?.sdp)!
                    ),
                    onCreateAnswer: { answerSDP -> Void in
                        self.sendSDP(sessionDescription: answerSDP)
                    }
                )
            } else if signalingMessage.type == "answer" {
                webRTCClient.receiveAnswer(
                    answerSDP: RTCSessionDescription(
                        type: .answer,
                        sdp: (signalingMessage.sessionDescription?.sdp)!
                    )
                )
            } else if signalingMessage.type == "candidate" {
                let candidate = signalingMessage.candidate!
                webRTCClient.receiveCandidate(
                    candidate: RTCIceCandidate(
                        sdp: candidate.sdp,
                        sdpMLineIndex: candidate.sdpMLineIndex,
                        sdpMid: candidate.sdpMid
                    )
                )
            }
        } catch {
            print(error)
        }
    }
    
    public func websocketDidReceiveData(socket: Starscream.WebSocketClient, data: Data) {
        print("data received")
    }
}

extension WebSocketWorker: WebRTCClientDelegate {
    public func didGenerateCandidate(iceCandidate: RTCIceCandidate) {
        sendCandidate(iceCandidate: iceCandidate)
    }
    
    public func didClientChecking() {
        delegate?.didClientChecking()
    }
    
    public func didClientConnected(statusChanged: @escaping () -> Void) {
        delegate?.didClientConnected(statusChanged: statusChanged)
    }
}
