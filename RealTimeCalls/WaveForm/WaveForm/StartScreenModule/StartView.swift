//
//  StartView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 13.04.23.
//

import SnapKit

public protocol StartViewEventsRespondable: AnyObject {
    func didCallButtonTapped()
    func didSecondButtonTapped()
}

public final class StartView: UIView {
    // MARK: - Subview Properties
    
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.setTitle("CALL", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var testButton = TestButton(frame: .zero)
    
    // MARK: - Private Properties
    
    private lazy var responder = Weak(firstResponder(of: StartViewEventsRespondable.self))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.current.background.mainColor
        testButton.setTitle("BUTTON", for: .normal)
        testButton.addTarget(self, action: #selector(secButtonTapped), for: .touchUpInside)
        addSubview(callButton)
        addSubview(testButton)
        callButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        testButton.snp.makeConstraints { make in
            make.top.equalTo(callButton.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        responder.object?.didCallButtonTapped()
    }
    
    @objc private func secButtonTapped() {
        responder.object?.didSecondButtonTapped()
    }
}
