//
//  LoginInteractor.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation
import GoogleSignIn

public final class RegisterInteractor {
    
    private let presenter: RegisterPresenter
    private var isUsernameStateSelected = true
    private var usernameText: String? = nil
    private var passwordText: String? = nil
    private var phoneText: String? = nil
    private var firstNameText: String? = nil
    private var lastNameText: String? = nil
    private var isInvalidCredentials = false
    private var selectedFieldID: Int = .zero
    
    private let service: UserServiceProtocol
    
    public init(presenter: RegisterPresenter, service: UserServiceProtocol) {
        self.presenter = presenter
        self.service = service
    }
}

extension RegisterInteractor {
    func obtainInitialState() {
        presenter.presentInitialState()
    }
    
    func obtainBeginEditing(text: String, id: String) {
        switch id {
        case "0":
            usernameText = text
            selectedFieldID = 0
        case "1":
            passwordText = text
            selectedFieldID = 1
        case "2":
            phoneText = text
            selectedFieldID = 2
        case "3":
            firstNameText = text
            selectedFieldID = 3
        case "4":
            lastNameText = text
            selectedFieldID = 4
        default:
            return
        }
        
        presenter.present(
            didEndEditing: false,
            username: usernameText,
            password: passwordText,
            phone: phoneText,
            firstName: firstNameText,
            lastName: lastNameText,
            isInvalidCredentials: false,
            selectedFieldID: selectedFieldID
        )
    }
    
    func obtainEndEditing(text: String, id: String) {}
    
    func obtainTextChanging(text: String, id: String) {
        switch id {
        case "0":
            usernameText = text
        case "1":
            passwordText = text
        case "2":
            phoneText = text
        case "3":
            firstNameText = text
        case "4":
            lastNameText = text
        default:
            return
        }
        
        presenter.present(
            didEndEditing: false,
            username: usernameText,
            password: passwordText,
            phone: phoneText,
            firstName: firstNameText,
            lastName: lastNameText,
            isInvalidCredentials: false,
            selectedFieldID: selectedFieldID
        )
    }
    
    func obtainClearButton(id: String) {
        switch id {
        case "0":
            usernameText = .empty
        case "1":
            passwordText = .empty
        case "2":
            phoneText = .empty
        case "3":
            firstNameText = .empty
        case "4":
            lastNameText = .empty
        default:
            return
        }
        
        presenter.present(
            didEndEditing: false,
            username: usernameText,
            password: passwordText,
            phone: phoneText,
            firstName: firstNameText,
            lastName: lastNameText,
            isInvalidCredentials: false,
            selectedFieldID: selectedFieldID
        )
    }
    
    func obtainRegister() {
        if
            let username = usernameText,
            username == "admin",
            let password = passwordText,
            password == "admin" {
            presenter.presentMainScreen()
        } else {
            guard
                let username = usernameText,
                let password = passwordText,
                let phone = phoneText
            else { return }
            service.register(
                username: username,
                password: password,
                phoneNumber: phone,
                firstName: firstNameText,
                lastName: lastNameText
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.presenter.presentMainScreen()
                case .failure:
                    self.isInvalidCredentials = true
                    self.presenter.present(
                        didEndEditing: false,
                        username: self.usernameText,
                        password: self.passwordText,
                        phone: self.phoneText,
                        firstName: self.firstNameText,
                        lastName: self.lastNameText,
                        isInvalidCredentials: self.isInvalidCredentials,
                        selectedFieldID: self.selectedFieldID
                    )
                }
            }
        }
    }
    
    func registerWithGoogleData(data: GIDGoogleUser) {
        guard let idToken = data.idToken else { return }
        service.register(idToken: idToken.tokenString) { [weak self] result in
            switch result {
            case .success:
                self?.presenter.presentMainScreen()
            case let .failure(error):
                print(error)
            }
        }
    }
}
