//
//  NetworkView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 14.03.23.
//

import UIKit
import SnapKit

public protocol StatusProtocol {}

public final class NetworkView: UIView, StatusProtocol {
    private let endCallImageView: UIImageView = {
        let image = UIImageView()
        image.image = Images.statusEndImage
        image.contentMode = .redraw
        return image
    }()
    
    private let animatableView = NetworkAnimatableView(frame: .zero)
    
    private lazy var timerView = TimerView(frame: .zero)
    
    private lazy var toastView = ToastView(frame: .zero)
    
    private lazy var containerView = UIView()
    
    private lazy var statusImageStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        toastView.isHidden = true
        endCallImageView.isHidden = true
        animatableView.isHidden = false
        toastView.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapped() {
        animatableView.tapped() {
            self.toastView.isHidden = false
            UIView.animate(
                withDuration: 0.3,
                delay: 0.0,
                options: [.curveEaseIn],
                animations: {
                    self.toastView.isHidden = false
                    self.toastView.alpha = 1
            })
            self.animate()
        }
    }
    
    func stopAll() {
        animatableView.isHidden = true
        endCallImageView.isHidden = false
        toastView.isHidden = true
        timerView.stopTimer()
    }
    
    private func addSubviews() {
        addSubview(stackView)
        containerView.addSubview(statusImageStackView)
        statusImageStackView.addArrangedSubview(animatableView)
        statusImageStackView.addArrangedSubview(endCallImageView)
        containerView.addSubview(animatableView)
        containerView.addSubview(timerView)
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(toastView)
    }
    
    private func makeConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        statusImageStackView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        endCallImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        timerView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(statusImageStackView.snp.trailing).offset(10)
        }
        
        containerView.snp.makeConstraints { make in
            make.width.equalTo(74)
        }
    }
    
    private func animate() {
        UIView.animate(
            withDuration: 0.2,
            delay: .zero,
            options: .curveEaseIn,
            animations: {
                let transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.toastView.transform = transform
            }, completion: { completed in
                if completed {
                    UIView.animate(
                        withDuration: 0.1,
                        delay: .zero,
                        usingSpringWithDamping: 2,
                        initialSpringVelocity: 5,
                        options: .curveEaseInOut,
                        animations: {
                            let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

                            self.toastView.transform = transform
                        },
                        completion: { completed in
                            if completed {
                                UIView.animate(withDuration: 0.2, delay: .zero, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut) {
                                    let transform = CGAffineTransform(scaleX: 1, y: 1)

                                    self.toastView.transform = transform
                                }
                            }
                        })
                }
            })
    }
}
