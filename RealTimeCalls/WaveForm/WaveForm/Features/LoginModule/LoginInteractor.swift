//
//  LoginInteractor.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation

public final class LoginInteractor {
    
    private let presenter: LoginPresenter
    private var isEmailSelected = true
    private var isInitialState = true
    private var emailText: String? = nil
    private var phoneText: String? = nil
    private var passwordText: String? = nil
    private var text: String? = nil
    private var id: String = "0"
    
    private let service: UserServiceProtocol
    
    public init(presenter: LoginPresenter, service: UserServiceProtocol) {
        self.presenter = presenter
        self.service = service
    }
}

extension LoginInteractor {
    func obtainInitialState() {
        presenter.presentInitialState(
            isEmailSelected: isEmailSelected,
            isInitialState: isInitialState,
            text: id == "1" ? passwordText : (isEmailSelected ? emailText : phoneText),
            id: id,
            didEndEditing: true,
            isNeedToReconfigureTextFields: true
        )
    }
    
    func switchSegment(isEmailSelected: Bool, isInitialState: Bool) {
        self.isEmailSelected = isEmailSelected
        self.isInitialState = isInitialState
        presenter.presentInitialState(
            isEmailSelected: isEmailSelected,
            isInitialState: isInitialState,
            text: id == "1" ? passwordText : (isEmailSelected ? emailText : phoneText),
            id: id,
            didEndEditing: true,
            isNeedToReconfigureTextFields: true
        )
    }
    
    func obtainBeginEditing(text: String, id: String) {
        if !text.isEmpty {
            if id == "1" {
                passwordText = text
            } else if isEmailSelected {
                emailText = text
            } else {
                phoneText = text
            }
        }
        self.id = id
        presenter.presentInitialState(
            isEmailSelected: isEmailSelected,
            isInitialState: isInitialState,
            text: id == "1" ? passwordText : (isEmailSelected ? emailText : phoneText),
            id: id,
            didEndEditing: false,
            isNeedToReconfigureTextFields: true
        )
    }
    
    func obtainEndEditing(text: String, id: String) {
        if !text.isEmpty {
//            if id == "1" {
//                passwordText = text
//            } else if isEmailSelected {
//                emailText = text
//            } else {
//                phoneText = text
//            }
        }
        self.id = id
        presenter.presentInitialState(
            isEmailSelected: isEmailSelected,
            isInitialState: isInitialState,
            text: id == "1" ? passwordText : (isEmailSelected ? emailText : phoneText),
            id: id,
            didEndEditing: true,
            isNeedToReconfigureTextFields: true
        )
    }
    
    func obtainTextChanging(text: String, id: String) {
        if id == "1" {
            passwordText = text
        } else if isEmailSelected {
            emailText = text
        } else {
            phoneText = text
        }
        self.id = id
        presenter.presentInitialState(
            isEmailSelected: isEmailSelected,
            isInitialState: isInitialState,
            text: id == "1" ? passwordText : (isEmailSelected ? emailText : phoneText),
            id: id,
            didEndEditing: false,
            isNeedToReconfigureTextFields: true
        )
    }
    
    func obtainClearButton() {
        switch id {
        case "0":
            if isEmailSelected {
                emailText = ""
            } else {
                phoneText = ""
            }
        case "1":
            passwordText = ""
        default:
            return
        }
        
        presenter.presentInitialState(
            isEmailSelected: isEmailSelected,
            isInitialState: isInitialState,
            text: id == "1" ? passwordText : (isEmailSelected ? emailText : phoneText),
            id: id,
            didEndEditing: false,
            isNeedToReconfigureTextFields: true
        )
    }
    
    func obtainLogin() {
        guard
            let email = emailText,
            let password = passwordText
        else { return }
        service.login(userName: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(token):
                self.service.getUserData(username: email, token: token.token) { [weak self] result in
                    switch result {
                    case let .success(user):
                        self?.presenter.presentMainScreen(user: user)
                    case let .failure(error):
                        print(error)
                    }
                }
                
//                self.presenter.presentInitialState(
//                    isEmailSelected: self.isEmailSelected,
//                    isInitialState: self.isInitialState,
//                    text: nil,
//                    id: "0",
//                    didEndEditing: false,
//                    isNeedToReconfigureTextFields: false
//                )
            case let .failure(error):
                self.presenter.showAlert(error: error)
                self.presenter.presentInitialState(
                    isEmailSelected: self.isEmailSelected,
                    isInitialState: self.isInitialState,
                    text: nil,
                    id: "0",
                    didEndEditing: false,
                    isNeedToReconfigureTextFields: false
                )
            }
        }
    }
}
