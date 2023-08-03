//
//  BottomBar.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 16.03.23.
//

import UIKit
import SnapKit

private extension Spacer {
    var closeButtonHeight: CGFloat { 50 }
    var stackViewHeight: CGFloat { 70 }
}

public protocol BottomBarEventsRespondable: AnyObject {
    func didTapEndButton()
    func didMuteButtonTapped(isOn: Bool)
    func didTapCloseButton()
    func speakerButtonTapped(isOn: Bool)
    func videoButtonTapped(isOn: Bool)
    func flipButtonTapped(isOn: Bool)
}

public final class BottomBar: UIView {
    private lazy var responder = Weak(firstResponder(of: BottomBarEventsRespondable.self))
    
    private lazy var speakerButton = BottomButton(
        image: Images.speakerImage,
        name: Texts.buttonSpeaker,
        type: .speaker,
        isFlippable: true
    )
    private lazy var videoButton = BottomButton(
        image: Images.videoImage,
        name: Texts.buttonVideo,
        type: .video,
        isFlippable: true
    )
    private lazy var muteButton = BottomButton(
        image: Images.muteImage,
        name: Texts.buttonMute,
        type: .mute,
        isFlippable: true
    )
    private lazy var endCallButton = BottomButton(
        image: Images.endCallImage,
        name: Texts.buttonEndCall,
        type: .end,
        isFlippable: true
    )
    private lazy var flipButton = BottomButton(
        image: Images.statusEndImage,
        name: Texts.flip,
        type: .flip,
        isFlippable: false
    )
    
    private lazy var closeButton = BottomCloseButton(frame: .zero)
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        closeButton.delegate = self
        closeButton.isHidden = true
        closeButton.alpha = .zero
        
        addSubview(stackView)
        addSubview(closeButton)
        
        speakerButton.delegate = self
        videoButton.delegate = self
        muteButton.delegate = self
        endCallButton.delegate = self
        flipButton.delegate = self
        
        stackView.addArrangedSubview(speakerButton)
        stackView.addArrangedSubview(videoButton)
        stackView.addArrangedSubview(muteButton)
        stackView.addArrangedSubview(endCallButton)
    }
    
    override public func layoutSubviews() {
        stackView.frame = CGRect(
            x: self.bounds.minX,
            y: self.bounds.minY,
            width: self.bounds.width,
            height: spacer.stackViewHeight
        )
        closeButton.frame = CGRect(
            x: self.bounds.maxX + spacer.space32,
            y: self.bounds.minY,
            width: self.bounds.width,
            height: spacer.closeButtonHeight
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showWithCloseButton() {
        self.closeButton.isHidden = false

        UIView.animate(withDuration: 0.4, delay: .zero, animations: {
            self.closeButton.alpha = 1
            self.stackView.alpha = .zero
            self.closeButton.frame = CGRect(
                x: self.bounds.minX,
                y: self.bounds.minY,
                width: self.bounds.width,
                height: self.spacer.closeButtonHeight
            )
        }, completion: { _ in
            self.stackView.isHidden = true
            self.closeButton.animate()
        })
    }
    
    public func reconfigureWithFlipButton() {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(flipButton)
        stackView.addArrangedSubview(videoButton)
        stackView.addArrangedSubview(muteButton)
        stackView.addArrangedSubview(endCallButton)
    }
    
    public func reconfigureWithSpeakerButton() {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(speakerButton)
        stackView.addArrangedSubview(videoButton)
        stackView.addArrangedSubview(muteButton)
        stackView.addArrangedSubview(endCallButton)
    }
}

extension BottomBar: BottomButtonDelegate {
    public func bottomButtonTapped(type: BottomButtonType, isOn: Bool) {
        switch type {
        case .speaker:
            responder.object?.speakerButtonTapped(isOn: isOn)
        case .video:
            responder.object?.videoButtonTapped(isOn: isOn)
        case .mute:
            responder.object?.didMuteButtonTapped(isOn: isOn)
        case .end:
            responder.object?.didTapEndButton()
        case .flip:
            responder.object?.flipButtonTapped(isOn: isOn)
        case .defaultType:
            return
        }
    }
}

extension BottomBar: BottomCloseButtonDelegate {
    func tapped() {
        responder.object?.didTapCloseButton()
    }
}
