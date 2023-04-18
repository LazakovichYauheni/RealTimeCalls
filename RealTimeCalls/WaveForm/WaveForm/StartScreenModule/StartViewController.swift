//
//  ViewController.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 31.03.22.
//

import UIKit
import SnapKit
import SwiftUI
import NotificationBannerSwift
import AVFoundation

public final class StartViewController: UIViewController {
    
    private let startView = StartView(frame: .zero)
    
    private var worker: WebSocketWorker!
    
    private var vc = ViewController()
    
    public override func loadView() {
        view = startView
        startView.delegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        worker = WebSocketWorker()
        worker.delegate = self
    }
}

extension StartViewController: StartViewDelegate {
    public func didCallButtonTapped() {
        worker.sendNotification()
        let contentViewController = ViewController()
        contentViewController.delegate = self
        vc = contentViewController
        contentViewController.modalPresentationStyle = .overFullScreen
        present(contentViewController, animated: true)
    }
}

extension StartViewController: WebSocketWorkerDelegate {
    public func didNeedToShowNotification() {
        DispatchQueue.main.async {
            let banner = FloatingNotificationBanner(title: "Incomming Call", subtitle: "Second device", style: .success)
            banner.autoDismiss = false
            banner.dismissOnTap = true
            banner.onTap = { [weak self] in
                guard let self = self else { return }
                self.worker.sendTapNotification()
                let contentViewController = ViewController()
                contentViewController.delegate = self
                self.vc = contentViewController
                contentViewController.modalPresentationStyle = .overFullScreen
                self.present(contentViewController, animated: true)
            }
            banner.show(cornerRadius: 12, shadowColor: UIColor(red: 0, green: 31 / 255, blue: 61 / 255, alpha: 0.04), shadowBlurRadius: 16)
        }
    }
    
    public func didClientChecking() {
        vc.didClientChecking()
    }
    
    public func didClientConnected(statusChanged: @escaping () -> Void) {
        vc.didClientConnected(statusChanged: statusChanged)
    }
    
    public func didDisconnect() {
        vc.didDisconnect()
    }
    
    public func needToShowRemoteVideo() {
        vc.showRemoteVideo()
    }
    
    public func needToShowLocalVideo() {
        vc.showLocalVideo()
    }
    
    public func needToHideRemoteVideo() {
        vc.hideRemoteVideo()
    }
    
    public func needToHideLocalVideo() {
        vc.hideLocalVideo()
    }
    
    public func needToFlip() {
        vc.flip()
    }
    
    public func setRemoteView(videoView: UIView) {
        vc.setRemoteView(videoView: videoView)
    }
    
    public func setLocalView(videoView: UIView) {
        vc.setLocalView(videoView: videoView)
    }
}

extension StartViewController: ViewControllerRespondable {
    func muteButtonTapped(isOn: Bool) {
        worker.mute(isOn: isOn)
    }
    
    func speakerButtonTapped(isOn: Bool) {
        worker.setSpeakerState(isOn: isOn)
    }
    
    func closeButtonTapped() {
        worker.disconnect()
    }
    
    func videoButtonTapped(
        isOn: Bool,
        cameraPosition: AVCaptureDevice.Position,
        needToAppearLocalVideoScreen: Bool,
        isJustFlipping: Bool
    ) {
        worker.setLocalVideoState(
            isOn: isOn,
            cameraPosition: cameraPosition,
            needToAppearLocalVideoScreen: needToAppearLocalVideoScreen,
            isJustFlipping: isJustFlipping
        )
    }
    
    func startTapped() {
        worker.sendLocalVideo()
    }
}
