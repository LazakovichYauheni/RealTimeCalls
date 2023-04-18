//
//  BottomBar.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 16.03.23.
//

import UIKit
import SnapKit

public protocol BottomBarDelegate: AnyObject {
    func didTapEndButton()
    func didMuteButtonTapped(isOn: Bool)
    func didTapCloseButton()
    func speakerButtonTapped(isOn: Bool)
    func videoButtonTapped(isOn: Bool)
    func flipButtonTapped(isOn: Bool)
}

public final class BottomBar: UIView {
    weak var delegate: BottomBarDelegate?
    
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
        
        addSubview(closeButton)
        addSubview(stackView)
        
        speakerButton.delegate = self
        videoButton.delegate = self
        muteButton.delegate = self
        endCallButton.delegate = self
        flipButton.delegate = self
        
        stackView.addArrangedSubview(speakerButton)
        stackView.addArrangedSubview(videoButton)
        stackView.addArrangedSubview(muteButton)
        stackView.addArrangedSubview(endCallButton)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showWithCloseButton() {
        
        UIView.animate(withDuration: 0.4, delay: .zero, animations: {
            self.stackView.isHidden = true
            self.closeButton.isHidden = false
        }, completion: { _ in
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
            delegate?.speakerButtonTapped(isOn: isOn)
        case .video:
            delegate?.videoButtonTapped(isOn: isOn)
        case .mute:
            delegate?.didMuteButtonTapped(isOn: isOn)
        case .end:
            delegate?.didTapEndButton()
        case .flip:
            delegate?.flipButtonTapped(isOn: isOn)
        case .defaultType:
            return
        }
    }
}

extension BottomBar: BottomCloseButtonDelegate {
    func tapped() {
        delegate?.didTapCloseButton()
    }
}
