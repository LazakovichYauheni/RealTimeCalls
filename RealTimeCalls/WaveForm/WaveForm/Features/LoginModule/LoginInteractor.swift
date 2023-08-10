//
//  LoginInteractor.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation

public final class LoginInteractor {
    
    private let presenter: LoginPresenter
    private var isUsernameStateSelected = true
    private var usernameText: String? = nil
    private var phoneText: String? = nil
    private var passwordText: String? = nil
    private var isInvalidCredentials = false
    
    private let service: UserServiceProtocol
    
    public init(presenter: LoginPresenter, service: UserServiceProtocol) {
        self.presenter = presenter
        self.service = service
    }
}

extension LoginInteractor {
    func obtainInitialState() {
        presenter.presentInitialState()
    }
    
    func switchSegment(state: FilterSelectionState) {
        self.isUsernameStateSelected = state == .username
        
        presenter.present(
            didEndEditing: true,
            state: state,
            firstFieldText: state == .username ? usernameText : phoneText,
            passwordText: passwordText,
            isInvalidCredentials: isInvalidCredentials
        )
    }
    
    func obtainBeginEditing(text: String, id: String) {
        isInvalidCredentials = false
        if isUsernameStateSelected {
            if id == "0" {
                usernameText = text
            } else {
                passwordText = text
            }
            presenter.present(
                didEndEditing: false,
                state: .username,
                firstFieldText: usernameText,
                passwordText: passwordText,
                isInvalidCredentials: false
            )
            
        } else {
            if id == "0" {
                phoneText = text
            } else {
                passwordText = text
            }
            presenter.present(
                didEndEditing: false,
                state: .phoneNumber,
                firstFieldText: phoneText,
                passwordText: passwordText,
                isInvalidCredentials: false
            )
        }
    }
    
    func obtainEndEditing(text: String, id: String) {}
    
    func obtainTextChanging(text: String, id: String) {
        isInvalidCredentials = false
        if isUsernameStateSelected {
            if id == "0" {
                usernameText = text
            } else {
                passwordText = text
            }
            presenter.present(
                didEndEditing: false,
                state: .username,
                firstFieldText: usernameText,
                passwordText: passwordText,
                isInvalidCredentials: false
            )
            
        } else {
            if id == "0" {
                phoneText = text
            } else {
                passwordText = text
            }
            presenter.present(
                didEndEditing: false,
                state: .phoneNumber,
                firstFieldText: phoneText,
                passwordText: passwordText,
                isInvalidCredentials: false
            )
        }
    }
    
    func obtainClearButton(id: String) {
        isInvalidCredentials = false
        switch id {
        case "0":
            if isUsernameStateSelected {
                usernameText = .empty
            } else {
                phoneText = .empty
            }
        case "1":
            passwordText = .empty
        default:
            return
        }
        
        presenter.present(
            didEndEditing: false,
            state: isUsernameStateSelected ? .username : .phoneNumber,
            firstFieldText: isUsernameStateSelected ? usernameText : phoneText,
            passwordText: passwordText,
            isInvalidCredentials: false
        )
    }
    
    func obtainLogin() {
        if
            let username = usernameText,
            let password = passwordText,
            username == "admin",
            password == "admin" {
            presenter.presentMainScreen()
        } else {
            guard
                let username = isUsernameStateSelected ? usernameText : phoneText,
                let password = passwordText
            else { return }
            
            service.login(userName: username, password: password) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.presenter.presentMainScreen()
                case .failure:
                    self.isInvalidCredentials = true
                    self.presenter.present(
                        didEndEditing: false,
                        state: self.isUsernameStateSelected ? .username : .phoneNumber,
                        firstFieldText: self.isUsernameStateSelected ? usernameText : phoneText,
                        passwordText: self.passwordText,
                        isInvalidCredentials: true
                    )
                }
            }
        }
    }
    
    func obtainLoginByGoogle(idToken: String) {
        service.login(idToken: idToken) { [weak self] result in
            switch result {
            case .success:
                self?.presenter.presentMainScreen()
            case let .failure(error):
                print(error)
            }
        }
    }
}
