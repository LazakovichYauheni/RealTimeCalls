//
//  WebRTCClient.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 11.04.23.
//

import Foundation
import WebRTC

public protocol WebRTCClientDelegate: NSObject {
    func didGenerateCandidate(iceCandidate: RTCIceCandidate)
    func didClientChecking()
    func didClientConnected()
}

public final class WebRTCClient: NSObject {
    private var peerConnectionFactory: RTCPeerConnectionFactory!
    private var peerConnection: RTCPeerConnection?
    private var localAudioTrack: RTCAudioTrack!
    private var dataChannel: RTCDataChannel?
    
    deinit {
        peerConnectionFactory = nil
        peerConnection = nil
    }

    weak var delegate: WebRTCClientDelegate?
    
    func setup() {
        peerConnectionFactory = RTCPeerConnectionFactory()
        localAudioTrack = createAudioTrack()
        localAudioTrack.isEnabled = false
    }
    
    func connect(onSuccess: @escaping (RTCSessionDescription) -> Void){
        peerConnection = setupPeerConnection()
        peerConnection!.delegate = self
        let xxx = peerConnectionFactory.mediaStream(withStreamId: "stream")
        xxx.addAudioTrack(localAudioTrack)
        peerConnection?.add(xxx)
        //peerConnection!.add(localAudioTrack, streamIds: ["stream0"])
        
        dataChannel = self.setupDataChannel()
        dataChannel?.delegate = self
        
        makeOffer(onSuccess: onSuccess)
    }
    
    func receiveOffer(offerSDP: RTCSessionDescription, onCreateAnswer: @escaping (RTCSessionDescription) -> Void){
        if peerConnection == nil {
            print("offer received, create peerconnection")
            peerConnection = setupPeerConnection()
            peerConnection!.delegate = self
            let xxx = peerConnectionFactory.mediaStream(withStreamId: "stream")
            xxx.addAudioTrack(localAudioTrack)
            peerConnection?.add(xxx)
            //peerConnection!.add(localAudioTrack, streamIds: ["stream-0"])
            
            dataChannel = setupDataChannel()
            dataChannel?.delegate = self
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
    
    private func createAudioTrack() -> RTCAudioTrack {
        let audioConstraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        let audioSource = self.peerConnectionFactory.audioSource(with: audioConstraints)
        let audioTrack = self.peerConnectionFactory.audioTrack(with: audioSource, trackId: "audio0")
        
        audioTrack.source.volume = 10
        audioTrack.isEnabled = false
        return audioTrack
    }
    
    private func setupPeerConnection() -> RTCPeerConnection {
        let rtcConf = RTCConfiguration()
        rtcConf.iceServers = [RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])]
        let mediaConstraints = RTCMediaConstraints.init(mandatoryConstraints: nil, optionalConstraints: nil)
        let pc = self.peerConnectionFactory.peerConnection(with: rtcConf, constraints: mediaConstraints, delegate: nil)
        return pc
    }
    
    private func setupDataChannel() -> RTCDataChannel{
        let dataChannelConfig = RTCDataChannelConfiguration()
        dataChannelConfig.channelId = 0
        
        let dataChannel = self.peerConnection?.dataChannel(forLabel: "dataChannel", configuration: dataChannelConfig)
        return dataChannel!
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
}

// MARK: - RTCPeerConnectionDelegate

extension WebRTCClient: RTCPeerConnectionDelegate {
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        switch stateChanged {
        case .closed:
            print("closed")
        case .stable:
            print("stable")
        case .haveLocalOffer:
            print("haveLocalOffer")
        case .haveLocalPrAnswer:
            print("haveLocalPrAnswer")
        case .haveRemoteOffer:
            print("haveRemoteOffer")
        case .haveRemotePrAnswer:
            print("haveRemotePrAnswer")
        }
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}
    
    public func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        switch newState {
        case .closed:
            print("closed")
        case .checking:
            print("checking")
            delegate?.didClientChecking()
        case .completed:
            print("completed")
        case .connected:
            print("connected")
            let xxx = peerConnection.localStreams
            localAudioTrack.isEnabled = true
            delegate?.didClientConnected()
        case .count:
            print("count")
        case .disconnected:
            print("disconnected")
        case .failed:
            print("failed")
        case .new:
            print("new")
        }
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {}
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        delegate?.didGenerateCandidate(iceCandidate: candidate)
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) { }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) { }
}

// MARK: - RTCDataChannelDelegate

extension WebRTCClient: RTCDataChannelDelegate {
    public func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {}
    
    public func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {}
}
