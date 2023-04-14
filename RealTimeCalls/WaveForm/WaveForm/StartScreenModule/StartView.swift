//
//  StartView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 13.04.23.
//

import SnapKit

public protocol StartViewDelegate: AnyObject {
    func didCallButtonTapped()
    func didAcceptButtonTapped()
}

public final class StartView: UIView {
    weak var delegate: StartViewDelegate?
    // MARK: - Private Properties
    
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.setTitle("CALL", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("ACCEPT", for: .normal)
        button.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 129 / 255, green: 107 / 255, blue: 214 / 255, alpha: 1)
        addSubview(callButton)
        addSubview(acceptButton)
        callButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(callButton.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        delegate?.didCallButtonTapped()
    }
    
    @objc private func acceptTapped() {
        delegate?.didAcceptButtonTapped()
    }
}
