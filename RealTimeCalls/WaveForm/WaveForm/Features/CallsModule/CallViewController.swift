//
//  ViewController.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 31.03.22.
//

import UIKit
import SnapKit
import AVFoundation

protocol CallViewControllerOutputProtocol: AnyObject {
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


private enum Constants {
    static let microphoneVolumeConstant: CGFloat = 200
}

final class CallViewController: UIViewController {
    // MARK: - Public Properties
    
    weak var delegate: CallViewControllerOutputProtocol?
    
    // MARK: - Private Properties
    
    private let contentableView = ContentableView()
    private let interactor: CallsInteractor
    private var microMonitor: MicrophoneMonitor?
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    
    // MARK: - Init
    
    public init(interactor: CallsInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.obtainInitialState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentableView.changeCallStatus(status: .requesting)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - Public Methods
    
    func display(title: String) {
        contentableView.setTitle(title: title)
    }
    
    func didClientChecking() {
        contentableView.changeCallStatus(status: .ringing)
    }
    
    func didClientConnected(statusChanged: @escaping () -> Void) {
        microMonitor = MicrophoneMonitor()
        contentableView.changeCallStatus(status: .speaking)
        statusChanged()
    }
    
    func didDisconnect() {
        /// DISPATCH руинит катку (дисмисс при анимации closeButton сразу срабатывает)
        //DispatchQueue.main.async {
            self.contentableView.changeCallStatus(status: .ending)
        do {
            try microMonitor?.audioSession.setActive(false)
        } catch {}
        //}
    }
    
    func showRemoteVideo() {
        contentableView.showRemoteVideoView()
    }
    
    func showLocalVideo() {
        contentableView.showLocalVideoView()
    }
    
    func hideRemoteVideo() {
        contentableView.hideRemoteVideoView()
    }
    
    func hideLocalVideo() {
        contentableView.hideLocalVideoView()
    }
    
    func flip() {
        contentableView.flipLocalVideoView()
    }
    
    func setRemoteView(videoView: UIView) {
        contentableView.configureRemoteVideoView(view: videoView)
    }
    
    func setLocalView(videoView: UIView) {
        contentableView.configureLocalVideoView(view: videoView)
    }
}

// MARK: - MicrophoneEventsDelegate

extension CallViewController: MicrophoneEventsDelegate {
    func didLevelChanged(value: CGFloat) {
        if value >= Constants.microphoneVolumeConstant {
            contentableView.updateLiquidSize(value: value)
        }
    }
}

// MARK: - LocalVideoViewEventsRespondable

extension CallViewController: LocalVideoViewEventsRespondable {
    func cancelButtonTapped() {
        currentCameraPosition = .front
        delegate?.videoButtonTapped(
            isOn: false,
            cameraPosition: .front,
            needToAppearLocalVideoScreen: true,
            isJustFlipping: false
        )
    }
    
    func startButtonTapped() {
        contentableView.remakeLocalVideoViewConstraints()
        delegate?.startTapped()
        contentableView.reconfigureBottomBarWithFlipButton()
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
}

// MARK: - BottomBarEventsRespondable

extension CallViewController: BottomBarEventsRespondable {
    func didTapEndButton() {
        delegate?.closeButtonTapped()
        contentableView.changeCallStatus(status: .ending)
    }
    
    func didMuteButtonTapped(isOn: Bool) {
        delegate?.muteButtonTapped(isOn: isOn)
    }
    
    func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    func speakerButtonTapped(isOn: Bool) {
        delegate?.speakerButtonTapped(isOn: isOn)
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
}

// MARK: - ContentableViewEventsRespondable

extension CallViewController: ContentableViewEventsRespondable {
    func setNeedToMonitorMicro() {
        microMonitor?.delegate = self
    }
}
