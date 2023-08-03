//
//  FieldsView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

public protocol FieldsViewEventsRespondable {
    func emailTapped()
    func phoneTapped()
}

public final class FieldsView: UIView {
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private lazy var usernameTextFieldView: FloatingTextFieldView = {
        let textFieldView = FloatingTextFieldView()
        textFieldView.clipsToBounds = true
        textFieldView.layer.cornerRadius = 12
        textFieldView.backgroundColor = .white
        return textFieldView
    }()
    
    private lazy var passwordTextFieldView: FloatingTextFieldView = {
        let textFieldView = FloatingTextFieldView()
        textFieldView.clipsToBounds = true
        textFieldView.layer.cornerRadius = 12
        textFieldView.backgroundColor = .white
        return textFieldView
    }()
    
    private lazy var responder = Weak(firstResponder(of: FieldsViewEventsRespondable.self))
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(stack)
        stack.addArrangedSubview(usernameTextFieldView)
        stack.addArrangedSubview(passwordTextFieldView)
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        usernameTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
}

extension FieldsView {
    struct ViewModel {
        let textFieldViewModels: [FloatingTextFieldView.ViewModel]
    }
    func configure(viewModel: FieldsView.ViewModel) {
        usernameTextFieldView.configure(with: viewModel.textFieldViewModels[0])
        passwordTextFieldView.configure(with: viewModel.textFieldViewModels[1])
        
        if viewModel.textFieldViewModels[0].isInvalidInput {
            usernameTextFieldView.layer.borderColor = UIColor(red: 224 / 255, green: 37 / 255, blue: 68 / 255, alpha: 1).cgColor
            usernameTextFieldView.layer.borderWidth = 1
        } else {
            usernameTextFieldView.layer.borderWidth = .zero
        }
    }
}
