//
//  ViewController.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 31.03.22.
//

import UIKit
import SnapKit
import SwiftUI
import AVFoundation

protocol ViewControllerRespondable: AnyObject {
    func muteButtonTapped(isOn: Bool)
    func speakerButtonTapped(isOn: Bool)
    func closeButtonTapped()
    func videoButtonTapped(
        isOn: Bool,
        cameraPosition: AVCaptureDevice.Position,
        needToAppearLocalVideoScreen: Bool,
        isJustFlipping: Bool
    )
    func startTapped()
}

class ViewController: UIViewController {
    weak var delegate: ViewControllerRespondable?
    
    let contentableView = ContentableView()
    var microMonitor: MicrophoneMonitor?
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    
    override func loadView() {
        view = contentableView
        microMonitor = MicrophoneMonitor()
        contentableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentableView.changeCallStatus(status: .requesting)
    }
    
    func didClientChecking() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.contentableView.changeCallStatus(status: .ringing)
        }
    }
    
    func didClientConnected(statusChanged: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.contentableView.changeCallStatus(status: .speaking)
            statusChanged()
        }
    }
    
    func didDisconnect() {
        /// DISPATCH руинит катку (дисмисс при анимации closeButton сразу срабатывает)
        DispatchQueue.main.async {
            self.contentableView.changeCallStatus(status: .ending)
        }
    }
    
    func showRemoteVideo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.contentableView.showRemoteVideoView()
        }
    }
    
    func showLocalVideo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.contentableView.showLocalVideoView()
        }
    }
    
    func hideRemoteVideo() {
        DispatchQueue.main.async {
            self.contentableView.hideRemoteVideoView()
        }
    }
    
    func hideLocalVideo() {
        DispatchQueue.main.async {
            self.contentableView.hideLocalVideoView()
        }
    }
    
    func flip() {
        DispatchQueue.main.async {
            self.contentableView.flipLocalVideoView()
        }
    }
    
    func setRemoteView(videoView: UIView) {
        DispatchQueue.main.async {
            self.contentableView.configureRemoteVideoView(view: videoView)
        }
    }
    
    func setLocalView(videoView: UIView) {
        DispatchQueue.main.async {
            self.contentableView.configureLocalVideoView(view: videoView)
        }
    }
}

extension ViewController: MicrophoneEventsDelegate {
    func didLevelChanged(value: CGFloat) {
        if value >= 200 {
            contentableView.updateLiquidSize(value: value)
        }
    }
}

extension ViewController: ContentableViewDelegate {
    func muteButtonTapped(isOn: Bool) {
        delegate?.muteButtonTapped(isOn: isOn)
    }
    
    func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    func speakerButtonTapped(isOn: Bool) {
        delegate?.speakerButtonTapped(isOn: isOn)
    }
    
    func endCallButtonTapped() {
        delegate?.closeButtonTapped()
    }
    
    func videoButtonTapped(isOn: Bool) {
        currentCameraPosition = .front
        delegate?.videoButtonTapped(
            isOn: isOn,
            cameraPosition: .front,
            needToAppearLocalVideoScreen: true,
            isJustFlipping: false
        )
    }
    
    func startTapped() {
        delegate?.startTapped()
    }
    
    func frontCameraSelected() {
        currentCameraPosition = .front
        delegate?.videoButtonTapped(
            isOn: true,
            cameraPosition: .front,
            needToAppearLocalVideoScreen: false,
            isJustFlipping: false
        )
    }
    
    func backCameraSelected() {
        currentCameraPosition = .back
        delegate?.videoButtonTapped(
            isOn: true,
            cameraPosition: .back,
            needToAppearLocalVideoScreen: false,
            isJustFlipping: false
        )
    }
    
    func flipButtonTapped(isOn: Bool) {
        let position: AVCaptureDevice.Position = currentCameraPosition == .back ? .front : .back
        currentCameraPosition = position
        delegate?.videoButtonTapped(
            isOn: true,
            cameraPosition: position,
            needToAppearLocalVideoScreen: false,
            isJustFlipping: true
        )
    }
    
    func setNeedMonitorMicro() {
        microMonitor?.delegate = self
    }
}
