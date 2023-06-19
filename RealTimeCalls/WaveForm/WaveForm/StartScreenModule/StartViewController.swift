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
    
    private let startView = StartView()
    
    private var worker: WebSocketWorker!
    
    private var callViewController = CallViewController()
    
    public override func loadView() {
        view = startView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        worker = WebSocketWorker()
        worker.delegate = self
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}

extension StartViewController: StartViewEventsRespondable {
    public func didCallButtonTapped() {
        worker.sendNotification()
        let contentViewController = CallViewController()
        contentViewController.delegate = self
        callViewController = contentViewController
        contentViewController.modalPresentationStyle = .overFullScreen
        present(contentViewController, animated: true)
    }
    
    public func didSecondButtonTapped() {
        let loginController = LoginAssembly().assemble()
        navigationController?.pushViewController(loginController, animated: true)
    }
}

extension StartViewController: WebSocketWorkerOutputProtocol {
    public func didNeedToShowNotification() {
        DispatchQueue.main.async {
            let banner = FloatingNotificationBanner(title: "Incomming Call", subtitle: "Second device", style: .success)
            banner.autoDismiss = false
            banner.dismissOnTap = true
            banner.onTap = { [weak self] in
                guard let self = self else { return }
                self.worker.sendTapNotification()
                let contentViewController = CallViewController()
                contentViewController.delegate = self
                self.callViewController = contentViewController
                contentViewController.modalPresentationStyle = .overFullScreen
                self.present(contentViewController, animated: true)
            }
            banner.show(cornerRadius: 12, shadowColor: UIColor(red: 0, green: 31 / 255, blue: 61 / 255, alpha: 0.04), shadowBlurRadius: 16)
        }
    }
    
    public func didClientChecking() {
        callViewController.didClientChecking()
    }
    
    public func didClientConnected(statusChanged: @escaping () -> Void) {
        callViewController.didClientConnected(statusChanged: statusChanged)
    }
    
    public func didDisconnect() {
        callViewController.didDisconnect()
    }
    
    public func needToShowRemoteVideo() {
        callViewController.showRemoteVideo()
    }
    
    public func needToShowLocalVideo() {
        callViewController.showLocalVideo()
    }
    
    public func needToHideRemoteVideo() {
        callViewController.hideRemoteVideo()
    }
    
    public func needToHideLocalVideo() {
        callViewController.hideLocalVideo()
    }
    
    public func needToFlip() {
        callViewController.flip()
    }
    
    public func setRemoteView(videoView: UIView) {
        callViewController.setRemoteView(videoView: videoView)
    }
    
    public func setLocalView(videoView: UIView) {
        callViewController.setLocalView(videoView: videoView)
    }
}

// MARK: - CallViewControllerOutputProtocol

extension StartViewController: CallViewControllerOutputProtocol {
    func muteButtonTapped(isOn: Bool) {
        worker.mute(isOn: isOn)
    }
    
    func speakerButtonTapped(isOn: Bool) {
        worker.setSpeakerState(isOn: isOn)
    }
    
    func closeButtonTapped() {
        worker.setLocalVideoState(
            isOn: false,
            cameraPosition: .back,
            needToAppearLocalVideoScreen: false,
            isJustFlipping: false
        )
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
