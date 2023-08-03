//
//  FieldsView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

public protocol RegisterFieldsViewEventsRespondable {
    func emailTapped()
    func phoneTapped()
}

public final class RegisterFieldsView: UIView {
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = spacer.space20
        return stack
    }()
    
    private lazy var usernameTextFieldView: FloatingTextFieldView = {
        let textFieldView = FloatingTextFieldView()
        textFieldView.clipsToBounds = true
        textFieldView.layer.cornerRadius = spacer.space12
        textFieldView.backgroundColor = .white
        return textFieldView
    }()
    
    private lazy var passwordTextFieldView: FloatingTextFieldView = {
        let textFieldView = FloatingTextFieldView()
        textFieldView.clipsToBounds = true
        textFieldView.layer.cornerRadius = spacer.space12
        textFieldView.backgroundColor = .white
        return textFieldView
    }()
    
    private lazy var phoneTextFieldView: FloatingTextFieldView = {
        let textFieldView = FloatingTextFieldView()
        textFieldView.clipsToBounds = true
        textFieldView.layer.cornerRadius = spacer.space12
        textFieldView.backgroundColor = .white
        return textFieldView
    }()
    
    private lazy var firstNameTextFieldView: FloatingTextFieldView = {
        let textFieldView = FloatingTextFieldView()
        textFieldView.clipsToBounds = true
        textFieldView.layer.cornerRadius = spacer.space12
        textFieldView.backgroundColor = .white
        return textFieldView
    }()
    
    private lazy var lastNameTextFieldView: FloatingTextFieldView = {
        let textFieldView = FloatingTextFieldView()
        textFieldView.clipsToBounds = true
        textFieldView.layer.cornerRadius = spacer.space12
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
        stack.addArrangedSubview(phoneTextFieldView)
        stack.addArrangedSubview(firstNameTextFieldView)
        stack.addArrangedSubview(lastNameTextFieldView)
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        usernameTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(spacer.space56)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(spacer.space56)
        }
        
        phoneTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(spacer.space56)
        }
        
        firstNameTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(spacer.space56)
        }
        
        lastNameTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(spacer.space56)
        }
    }
}

extension RegisterFieldsView {
    struct ViewModel {
        let textFieldViewModels: [FloatingTextFieldView.ViewModel]
    }
    func configure(viewModel: FieldsView.ViewModel) {
        usernameTextFieldView.configure(with: viewModel.textFieldViewModels[0])
        passwordTextFieldView.configure(with: viewModel.textFieldViewModels[1])
        phoneTextFieldView.configure(with: viewModel.textFieldViewModels[2])
        firstNameTextFieldView.configure(with: viewModel.textFieldViewModels[3])
        lastNameTextFieldView.configure(with: viewModel.textFieldViewModels[4])
        
        if viewModel.textFieldViewModels[0].isInvalidInput {
            usernameTextFieldView.layer.borderColor = UIColor(red: 224 / 255, green: 37 / 255, blue: 68 / 255, alpha: 1).cgColor
            usernameTextFieldView.layer.borderWidth = 1
        } else {
            usernameTextFieldView.layer.borderWidth = .zero
        }
        
        if viewModel.textFieldViewModels[1].isInvalidInput {
            passwordTextFieldView.layer.borderColor = UIColor(red: 224 / 255, green: 37 / 255, blue: 68 / 255, alpha: 1).cgColor
            passwordTextFieldView.layer.borderWidth = 1
        } else {
            passwordTextFieldView.layer.borderWidth = .zero
        }
        
        if viewModel.textFieldViewModels[2].isInvalidInput {
            phoneTextFieldView.layer.borderColor = UIColor(red: 224 / 255, green: 37 / 255, blue: 68 / 255, alpha: 1).cgColor
            phoneTextFieldView.layer.borderWidth = 1
        } else {
            phoneTextFieldView.layer.borderWidth = .zero
        }
    }
}
