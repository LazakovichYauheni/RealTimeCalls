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
        stack.spacing = spacer.space20
        return stack
    }()
    
    private lazy var emailTextFieldView: FloatingTextFieldView = {
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
        stack.addArrangedSubview(emailTextFieldView)
        stack.addArrangedSubview(passwordTextFieldView)
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emailTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(spacer.space56)
        }
        
        passwordTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(spacer.space56)
        }
    }
}

extension FieldsView {
    struct ViewModel {
        let textFieldViewModels: [FloatingTextFieldView.ViewModel]
    }
    func configure(viewModel: FieldsView.ViewModel) {
        emailTextFieldView.configure(with: viewModel.textFieldViewModels[0])
        passwordTextFieldView.configure(with: viewModel.textFieldViewModels[1])
        
        if viewModel.textFieldViewModels[0].isInvalidInput {
            emailTextFieldView.layer.borderColor = UIColor(red: 224 / 255, green: 37 / 255, blue: 68 / 255, alpha: 1).cgColor
            emailTextFieldView.layer.borderWidth = 1
        } else {
            emailTextFieldView.layer.borderWidth = .zero
        }
    }
}
