//
//  StartView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 13.04.23.
//

import SnapKit

public protocol StartViewEventsRespondable: AnyObject {
    func didCallButtonTapped()
}

public final class StartView: UIView {
    // MARK: - Subview Properties
    
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.setTitle("CALL", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private Properties
    
    private lazy var responder = Weak(firstResponder(of: StartViewEventsRespondable.self))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 129 / 255, green: 107 / 255, blue: 214 / 255, alpha: 1)
        addSubview(callButton)
        callButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        responder.object?.didCallButtonTapped()
    }
}
