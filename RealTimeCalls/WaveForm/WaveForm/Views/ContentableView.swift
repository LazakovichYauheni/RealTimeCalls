//
//  ContentView.swift
//  ContentableView
//
//  Created by Eugeni Lazakovich on 12.03.23.
//

import UIKit
import SnapKit

private extension Spacer {
    var space50: CGFloat { 50 }
    var bottomBarHeight: CGFloat { 70 }
}

protocol ContentableViewEventsRespondable: AnyObject {
    func setNeedToMonitorMicro()
}

private enum Constants {
    static let imageCornerRadius = 57.5
    static let liquidViewVolumeAnimationDuration = 0.05
    static let liquidViewVolumeConstant: CGFloat = 200

    static let flipCameraAnimationDuration = 0.3
    static let circleAppearanceAnimationDuration = 0.24
    static let halfDelimiter: CGFloat = 2
    static let powConstant: Float = 2
    
    static let imageOffset = -100
    static let imageSize = 115
    static let liquidViewSize = 200
    
    static let upscalingAnimationDuration = 0.2
    static let upscalingTransformConstant: CGFloat = 1.5
    static let upscalingImageTransformConstant: CGFloat = 1.2
    
    static let downscalingAnimationDuration = 0.2
    static let downscalingTransformConstant: CGFloat = 0.9
    static let downscalingDamping: CGFloat = 2
    static let downscalingVelocity: CGFloat = 5
    
    static let requestingAnimationDuration = 1.2
    static let requestingTransformConstant: CGFloat = 1.05
    
    static let initialScaleAnimationDuration = 0.2
    static let initialScaleTransformConstant: CGFloat = 1
    static let initialScaleDamping: CGFloat = 0.6
    static let initialScaleVelocity: CGFloat = 5
}

final class ContentableView: UIView {
    // MARK: - Subview Properties
    
    private lazy var remoteVideoView: RemoteVideoView = {
        let view = RemoteVideoView()
        view.isHidden = true
        return view
    }()
    
    private lazy var localVideoView: LocalVideoView = {
        let view = LocalVideoView()
        view.isHidden = true
        return view
    }()
    
    private lazy var backgroundView = BackgroundView()
    
    private lazy var liquidView = LiquidView()
    
    private lazy var secondLiquidView = LiquidView()

    private lazy var networkView = NetworkView()
    
    private lazy var userImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.imageCornerRadius
        view.image = Images.girlImage
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.Regular.regular25
        label.textAlignment = .center
        label.text = Texts.callingName
        return label
    }()
    
    private lazy var statusView: AllStatusView = {
        let firstStatusView = StatusView(text: Texts.statusResponding)
        let statusView = AllStatusView(statusView: firstStatusView)
        return statusView
    }()
    
    private lazy var bottomBar = BottomBar()
    
    private lazy var rateCallView: RateCallView = {
        let rateView = RateCallView()
        rateView.alpha = .zero
        rateView.isHidden = true
        return rateView
    }()
    
    // MARK: - Private Properties
    
    private lazy var responder = Weak(firstResponder(of: ContentableViewEventsRespondable.self))
    
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
                withDuration: Constants.liquidViewVolumeAnimationDuration,
                delay: .zero,
                options: .curveLinear,
                animations: {
                    let transform = CGAffineTransform(
                        scaleX: value / Constants.liquidViewVolumeConstant,
                        y: value / Constants.liquidViewVolumeConstant
                    )
                    
                    self.liquidView.transform = transform
                    self.secondLiquidView.transform = transform
                }
            )
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
    
    public func reconfigureBottomBarWithFlipButton() {
        bottomBar.reconfigureWithFlipButton()
    }
    
    public func remakeLocalVideoViewConstraints() {
//        let width = bounds.width / Constants.localVideoViewWidthConstant
//        let height = bounds.height / Constants.localVideoViewHeightConstant
//        
//        UIView.animate(withDuration: Constants.localVideoViewAnimationDuration, delay: .zero) {
//            self.localVideoView.snp.remakeConstraints { make in
//                make.bottom.equalToSuperview().inset(Constants.localVideoViewSmallBottomConstant)
//                make.leading.equalToSuperview().priority(.low)
//                make.trailing.equalToSuperview().inset(Constants.space16)
//                make.width.equalTo(width)
//                make.height.equalTo(height)
//            }
//            self.layoutIfNeeded()
//        }
    }
    
    public func flipLocalVideoView() {
        UIView.transition(
            with: localVideoView,
            duration: Constants.flipCameraAnimationDuration,
            options: .transitionFlipFromLeft,
            animations: nil,
            completion: nil
        )
    }
    
    public func showRemoteVideoView() {
        remoteVideoView.isHidden = false
        applyCircleAnimationForVideoView(
            appear: true,
            remoteVideoView,
            duration: Constants.circleAppearanceAnimationDuration,
            from: userImageView.center
        ) {}
    }
    
    public func showLocalVideoView() {
        localVideoView.isHidden = false
        localVideoView.showButtons()
        applyCircleAnimationForVideoView(
            appear: true,
            localVideoView,
            duration: Constants.circleAppearanceAnimationDuration,
            from: tappedPoint
        ) {}
    }
    
    public func hideRemoteVideoView() {
        applyCircleAnimationForVideoView(
            appear: false,
            remoteVideoView,
            duration: Constants.circleAppearanceAnimationDuration,
            from: userImageView.center
        ) {
            self.remoteVideoView.isHidden = true
        }
    }
    
    public func hideLocalVideoView() {
        bottomBar.reconfigureWithSpeakerButton()
        localVideoView.isHidden = true
        localVideoView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func applyCircleAnimationForVideoView(
        appear: Bool,
        _ view: UIView,
        duration: CFTimeInterval,
        from point: CGPoint,
        completion: @escaping () -> Void
    ) {
        let maskDiameter = CGFloat(
            sqrtf(
                powf(Float(view.bounds.width + point.x), Constants.powConstant)
                + powf(Float(view.bounds.height + point.y), Constants.powConstant)
            )
        )
        let mask = CAShapeLayer()
        let animationId = "path"

        // Make a circular shape.
        mask.path = UIBezierPath(
            roundedRect: CGRect(x: .zero, y: .zero, width: maskDiameter, height: maskDiameter),
            cornerRadius: maskDiameter / Constants.halfDelimiter
        ).cgPath

        // Center the shape in the view.
        mask.position = CGPoint(
            x: (-maskDiameter) / Constants.halfDelimiter + point.x,
            y: (-maskDiameter) / Constants.halfDelimiter + point.y
        )

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
        
        let newPath = UIBezierPath(
            roundedRect: CGRect(
                x: maskDiameter / Constants.halfDelimiter,
                y: maskDiameter / Constants.halfDelimiter,
                width: .zero,
                height: .zero
            ),
            cornerRadius: .zero
        ).cgPath

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
            blobsColors: configurationParameters.background.description.blobColors,
            backgroundColor: configurationParameters.background.description.backgroundColor
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
                showRateCallView()
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
        addSubview(backgroundView)
        addSubview(liquidView)
        addSubview(secondLiquidView)
        addSubview(userImageView)
        addSubview(titleLabel)
        addSubview(statusView)
        addSubview(remoteVideoView)
        addSubview(rateCallView)
        addSubview(bottomBar)
        addSubview(localVideoView)
    }
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        liquidView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(Constants.imageOffset)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: Constants.liquidViewSize, height: Constants.liquidViewSize))
        }
        
        secondLiquidView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(Constants.imageOffset)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: Constants.liquidViewSize, height: Constants.liquidViewSize))
        }
        
        userImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(Constants.imageOffset)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: Constants.imageSize, height: Constants.imageSize))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(spacer.space16)
            make.leading.trailing.equalToSuperview()
        }
        
        statusView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space8)
            make.centerX.equalToSuperview()
        }
        
        remoteVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rateCallView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomBar.snp.top).offset(
                UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? .zero == .zero
                ? -25
                : -66
            )
            make.leading.trailing.equalToSuperview().inset(spacer.space30)
        }
        
        bottomBar.snp.makeConstraints { make in
            make.height.equalTo(spacer.bottomBarHeight)
            make.bottom.equalTo(safeAreaInsets.bottom).inset(spacer.space20 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? .zero))
            make.leading.trailing.equalToSuperview().inset(spacer.space30)
        }
        
        localVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func animateUpscaling() {
        UIView.animate(
            withDuration: Constants.upscalingAnimationDuration,
            delay: .zero,
            options: .curveEaseIn,
            animations: {
                let transform = CGAffineTransform(
                    scaleX: Constants.upscalingTransformConstant,
                    y: Constants.upscalingTransformConstant
                )
                let imageTransform = CGAffineTransform(
                    scaleX: Constants.upscalingImageTransformConstant,
                    y: Constants.upscalingImageTransformConstant
                )
                
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
            withDuration: Constants.downscalingAnimationDuration,
            delay: .zero,
            usingSpringWithDamping: Constants.downscalingDamping,
            initialSpringVelocity: Constants.downscalingVelocity,
            options: .curveEaseInOut,
            animations: {
                let transform = CGAffineTransform(
                    scaleX: Constants.downscalingTransformConstant,
                    y: Constants.downscalingTransformConstant
                )

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
            withDuration: Constants.requestingAnimationDuration,
            delay: .zero,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: {
                let transform = CGAffineTransform(
                    scaleX: Constants.requestingTransformConstant,
                    y: Constants.requestingTransformConstant
                )
                self.userImageView.transform = transform
            }
        )
    }
    
    private func animateInitialScale() {
        UIView.animate(
            withDuration: Constants.initialScaleAnimationDuration,
            delay: .zero,
            usingSpringWithDamping: Constants.initialScaleDamping,
            initialSpringVelocity: Constants.initialScaleVelocity,
            options: .curveEaseInOut,
            animations: {
                let transform = CGAffineTransform(
                    scaleX: Constants.initialScaleTransformConstant,
                    y: Constants.initialScaleTransformConstant
                )

                self.userImageView.transform = transform
                self.liquidView.transform = transform
                self.secondLiquidView.transform = transform
            }, completion: { _ in
                self.responder.object?.setNeedToMonitorMicro()
            }
        )
    }
    
    private func showRateCallView() {
        UIView.animate(withDuration: 0.4, delay: .zero, animations: {
            self.rateCallView.alpha = 1
            self.rateCallView.isHidden = false
        })
    }
}
