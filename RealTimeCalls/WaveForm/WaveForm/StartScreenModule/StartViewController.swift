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

public final class StartViewController: UIViewController {
    
    private let startView = StartView(frame: .zero)
    
    private let contentViewController = ViewController()
    private var worker: WebSocketWorker!
    
    public override func loadView() {
        view = startView
        startView.delegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.worker = WebSocketWorker()
        self.worker.delegate = self
    }
    
    private func startCallView() {
        contentViewController.modalPresentationStyle = .overFullScreen
        present(contentViewController, animated: true)
    }
}

extension StartViewController: StartViewDelegate {
    public func didCallButtonTapped() {
//        worker = WebSocketWorker()
//        worker.delegate = self
        worker.sendNotification()
        //worker.call()
        contentViewController.modalPresentationStyle = .overFullScreen
        present(contentViewController, animated: true)
    }
    
    public func didAcceptButtonTapped() {
        worker = WebSocketWorker()
        worker.delegate = self
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
                self.contentViewController.modalPresentationStyle = .overFullScreen
                self.present(self.contentViewController, animated: true)
            }
            banner.show(cornerRadius: 12, shadowColor: UIColor(red: 0, green: 31 / 255, blue: 61 / 255, alpha: 0.04), shadowBlurRadius: 16)
        }
    }
    
    public func didClientChecking() {
        contentViewController.didClientChecking()
    }
    
    public func didClientConnected() {
        contentViewController.didClientConnected()
    }
}
