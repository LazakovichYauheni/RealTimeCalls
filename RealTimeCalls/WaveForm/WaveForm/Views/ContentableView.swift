//
//  ContentView.swift
//  ContentableView
//
//  Created by Eugeni Lazakovich on 12.03.23.
//

import UIKit
import SnapKit

protocol ContentableViewDelegate: AnyObject {
    func muteButtonTapped(isOn: Bool)
    func closeButtonTapped()
    func speakerButtonTapped(isOn: Bool)
    func endCallButtonTapped()
    func videoButtonTapped(isOn: Bool)
    func flipButtonTapped(isOn: Bool)
    func startTapped()
    func frontCameraSelected()
    func backCameraSelected()
    func setNeedMonitorMicro()
}

final class ContentableView: UIView {
    weak var delegate: ContentableViewDelegate?
    // MARK: - Subview Properties
    
    private lazy var remoteVideoView: RemoteVideoView = {
        let view = RemoteVideoView(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    private lazy var localVideoView: LocalVideoView = {
        let view = LocalVideoView(frame: .zero)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    private let backgroundView = BackgroundView(frame: .zero)
    
    private lazy var liquidView = LiquidView(frame: .zero)
    
    private lazy var secondLiquidView = LiquidView(frame: .zero)

    private lazy var networkView = NetworkView(frame: .zero)
    
    private lazy var userImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 57.5
        view.image = Images.girlImage
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(FontSize.size25)
        label.textAlignment = .center
        label.text = Texts.callingName
        return label
    }()
    
    private lazy var statusView: AllStatusView = {
        let firstStatusView = StatusView(text: Texts.statusResponding)
        let statusView = AllStatusView(statusView: firstStatusView)
        return statusView
    }()
    
    private lazy var bottomBar = BottomBar(frame: .zero)
    
    // MARK: - Private Properties
    
    private var tappedPoint: CGPoint = CGPoint()
    private var previousStatusView: StatusProtocol?
    private let configurator = CallScreenConfigurator()
    private var configurationParameters: ConfigurationParameters? {
        didSet {
            guard let parameters = configurationParameters else { return }
            configure(configurationParameters: parameters)
        }
    }
    
    private var status: CallStatus = .requesting {
        didSet {
            switch status {
            case .requesting:
                configurationParameters = configurator.configurationForRequesting()
            case .ringing:
                configurationParameters = configurator.configurationForRinging()
            case .exchangingKeys:
                configurationParameters = configurator.configurationForExchanging()
            case .speaking:
                configurationParameters = configurator.configurationForSpeaking()
            case .weakSignalSpeaking:
                configurationParameters = configurator.configationForWeakSignalRinging()
            case .ending:
                configurationParameters = configurator.configationForEnding()
            }
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if tappedPoint.x == .zero {
            tappedPoint = point
        }
        let hitView = super.hitTest(point, with: event)
        return hitView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func updateLiquidSize(value: CGFloat) {
        if status == .speaking || status == .weakSignalSpeaking {
            UIView.animate(
                withDuration: 0.05,
                delay: .zero,
                options: .curveLinear,
                animations: {
                    let transform = CGAffineTransform(scaleX: value / 200, y: value / 200)
                    
                    self.liquidView.transform = transform
                    self.secondLiquidView.transform = transform
                })
        }
    }
    
    public func changeCallStatus(status: CallStatus) {
        self.status = status
    }
    
    public func configureRemoteVideoView(view: UIView) {
        remoteVideoView.configure(videoView: view)
    }
    
    public func configureLocalVideoView(view: UIView) {
        localVideoView.configure(videoView: view)
    }
    
    public func flipLocalVideoView() {
        UIView.transition(with: localVideoView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    public func showRemoteVideoView() {
        remoteVideoView.isHidden = false
        circleAnim(appear: true, remoteVideoView, duration: 0.24, from: userImageView.center) {}
    }
    
    public func showLocalVideoView() {
        localVideoView.isHidden = false
        localVideoView.showButtons()
        circleAnim(appear: true, localVideoView, duration: 0.24, from: tappedPoint) {}
    }
    
    public func hideRemoteVideoView() {
        circleAnim(appear: false, remoteVideoView, duration: 0.24, from: userImageView.center) {
            self.remoteVideoView.isHidden = true
        }
    }
    
    public func hideLocalVideoView() {
        bottomBar.reconfigureWithSpeakerButton()
        self.localVideoView.isHidden = true
        self.localVideoView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func circleAnim(appear: Bool, _ view: UIView, duration: CFTimeInterval, from point: CGPoint, completion: @escaping () -> Void) {
        let maskDiameter = CGFloat(sqrtf(powf(Float(view.bounds.width + point.x), 2) + powf(Float(view.bounds.height + point.y), 2)))
        let mask = CAShapeLayer()
        let animationId = "path"

        // Make a circular shape.
        mask.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: maskDiameter, height: maskDiameter), cornerRadius: maskDiameter / 2).cgPath

        // Center the shape in the view.
        mask.position = CGPoint(x: (-maskDiameter ) / 2 + point.x, y: (-maskDiameter) / 2 + point.y)

        // Fill the circle.
        mask.fillColor = UIColor.black.cgColor

        // Add as a mask to the parent layer.
        view.layer.mask = mask
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        // Animate.
        let animation = CABasicAnimation(keyPath: animationId)
        animation.duration = duration
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.isRemovedOnCompletion = false
        
        let newPath = UIBezierPath(roundedRect: CGRect(x: maskDiameter / 2, y: maskDiameter / 2, width: 0, height: 0), cornerRadius: 0).cgPath

        // Set start and end values.
        animation.fromValue = appear ? newPath : mask.path
        animation.toValue = appear ? mask.path : newPath

        // Start the animation.
        mask.add(animation, forKey: animationId)
        CATransaction.commit()
    }
    
    // MARK: - Private Methods
    
    private func configure(configurationParameters: ConfigurationParameters) {
        backgroundView.changeColors(
            blobsColors: configurationParameters.background.description.1,
            backgroundColor: configurationParameters.background.description.0
        )
        
        switch configurationParameters.statusText {
        case .network:
            if
                let previousStatusView = previousStatusView,
                !(previousStatusView is NetworkView) {
                statusView.transition(view: networkView)
                self.previousStatusView = networkView
            }
            
            if configurationParameters.isWeakToastNeeded {
                networkView.tapped()
            }
            
            if status == .ending {
                networkView.stopAll()
                bottomBar.showWithCloseButton()
            }
            
        case let .text(text):
            if text == Texts.statusRequesting {
                animateImageWhenRequesting()
            }
            let statusView = StatusView(text: text)
            previousStatusView = statusView
            
            self.statusView.transition(view: StatusView(text: text))
        }
        
        if status == .speaking {
            animateUpscaling()
        }
    }
    
    private func initialize() {
        //maskingView.blur()
        bottomBar.delegate = self
        addSubview(backgroundView)
        addSubview(liquidView)
        addSubview(secondLiquidView)
        addSubview(userImageView)
        addSubview(titleLabel)
        addSubview(statusView)
        addSubview(remoteVideoView)
        addSubview(bottomBar)
        addSubview(localVideoView)
    }
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        liquidView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        secondLiquidView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        userImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 115, height: 115))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        statusView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        remoteVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }
        
        localVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func animateUpscaling() {
        UIView.animate(
            withDuration: 0.2,
            delay: .zero,
            options: .curveEaseIn,
            animations: {
                let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                let imageTransform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                
                self.userImageView.transform = imageTransform
                self.liquidView.transform = transform
                self.secondLiquidView.transform = transform
            }, completion: { completed in
                if completed {
                    self.animateDownscaling()
                }
            })
    }
    
    private func animateDownscaling() {
        UIView.animate(
            withDuration: 0.2,
            delay: .zero,
            usingSpringWithDamping: 2,
            initialSpringVelocity: 5,
            options: .curveEaseInOut,
            animations: {
                let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

                self.userImageView.transform = transform
                self.liquidView.transform = transform
                self.secondLiquidView.transform = transform
            },
            completion: { completed in
                if completed {
                    self.animateInitialScale()
                }
            })
    }
    
    private func animateImageWhenRequesting() {
        UIView.animate(
            withDuration: 1.2,
            delay: .zero,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: {
                let transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.userImageView.transform = transform
            }
        )
    }
    
    private func animateInitialScale() {
        UIView.animate(withDuration: 0.2, delay: .zero, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            let transform = CGAffineTransform(scaleX: 1, y: 1)

            self.userImageView.transform = transform
            self.liquidView.transform = transform
            self.secondLiquidView.transform = transform
        }, completion: { _ in self.delegate?.setNeedMonitorMicro() })
    }
}

extension ContentableView: BottomBarDelegate {
    func didTapEndButton() {
        delegate?.endCallButtonTapped()
        changeCallStatus(status: .ending)
    }
    
    func didMuteButtonTapped(isOn: Bool) {
        delegate?.muteButtonTapped(isOn: isOn)
    }
    
    func didTapCloseButton() {
        delegate?.closeButtonTapped()
    }
    
    func speakerButtonTapped(isOn: Bool) {
        delegate?.speakerButtonTapped(isOn: isOn)
    }
    
    func videoButtonTapped(isOn: Bool) {
        delegate?.videoButtonTapped(isOn: isOn)
    }
    
    func flipButtonTapped(isOn: Bool) {
        delegate?.flipButtonTapped(isOn: isOn)
    }
}

extension ContentableView: LocalVideoViewProtocol {
    func closeTapped() {
        delegate?.videoButtonTapped(isOn: false)
    }
    
    func startTapped() {
        let width = bounds.width / 3.12
        let height = bounds.height / 4.22
        
        UIView.animate(withDuration: 0.5, delay: .zero) {
            self.localVideoView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().inset(200)
                make.leading.equalToSuperview().priority(.low)
                make.trailing.equalToSuperview().inset(16)
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            self.layoutIfNeeded()
        }
        delegate?.startTapped()
        bottomBar.reconfigureWithFlipButton()
    }
    
    func frontCameraSelected() {
        delegate?.frontCameraSelected()
    }
    
    func backCameraSelected() {
        delegate?.backCameraSelected()
    }
}
