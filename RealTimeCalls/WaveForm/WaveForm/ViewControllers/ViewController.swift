//
//  ViewController.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 31.03.22.
//

import UIKit
import SnapKit
import SwiftUI

protocol ViewControllerRespondable: AnyObject {
    func muteButtonTapped(isOn: Bool)
}

class ViewController: UIViewController {
    weak var delegate: ViewControllerRespondable?
    
    let contentableView = ContentableView()
    
    override func loadView() {
        let microMonitor = MicrophoneMonitor()
        microMonitor.delegate = self
        view = contentableView
        contentableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentableView.changeCallStatus(status: .requesting)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.contentableView.changeCallStatus(status: .ringing)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.contentableView.changeCallStatus(status: .exchangingKeys)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
//            self.contentableView.changeCallStatus(status: .speaking)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            self.contentableView.changeCallStatus(status: .weakSignalSpeaking)
//        }
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
}
