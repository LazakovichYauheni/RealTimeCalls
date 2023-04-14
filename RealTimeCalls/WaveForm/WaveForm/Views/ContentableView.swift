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
}

final class ContentableView: UIView {
    weak var delegate: ContentableViewDelegate?
    // MARK: - Subview Properties
    
    private let backgroundView = BackgroundView(frame: .zero)
    
    private lazy var liquidView = LiquidView(frame: .zero)
    
    private lazy var secondLiquidView = LiquidView(frame: .zero)
    
    private lazy var thirdLiquidView = LiquidView(frame: .zero)

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
                    self.thirdLiquidView.transform = transform
                })
        }
    }
    
    public func changeCallStatus(status: CallStatus) {
        self.status = status
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
            }
            
        case let .text(text):
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
        addSubview(thirdLiquidView)
        addSubview(userImageView)
        addSubview(titleLabel)
        addSubview(statusView)
        addSubview(bottomBar)
        
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

        thirdLiquidView.snp.makeConstraints { make in
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
        
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }
    }
    
    @objc private func secondTapped() {
        networkView.tapped()
    }
    
    private func animateUpscaling() {
        UIView.animate(
            withDuration: 0.3,
            delay: .zero,
            options: .curveEaseIn,
            animations: {
                let transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                let imageTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
                self.userImageView.transform = imageTransform
                self.liquidView.transform = transform
                self.secondLiquidView.transform = transform
                self.thirdLiquidView.transform = transform
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
                self.thirdLiquidView.transform = transform
            },
            completion: { completed in
                if completed {
                    self.animateInitialScale()
                }
            })
    }
    
    private func animateInitialScale() {
        UIView.animate(withDuration: 0.4, delay: .zero, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut) {
            let transform = CGAffineTransform(scaleX: 1, y: 1)

            self.userImageView.transform = transform
            self.liquidView.transform = transform
            self.secondLiquidView.transform = transform
            self.thirdLiquidView.transform = transform
        }
    }
}

extension ContentableView: BottomBarDelegate {
    func didTapEndButton() {
        changeCallStatus(status: .ending)
    }
    
    func didMuteButtonTapped(isOn: Bool) {
        delegate?.muteButtonTapped(isOn: isOn)
    }
}
