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
    
    public init(presenter: LoginPresenter) {
        self.presenter = presenter
    }
}

extension LoginInteractor {
    func obtainInitialState() {
        presenter.presentInitialState(
            isEmailSelected: isEmailSelected,
            isInitialState: isInitialState,
            text: id == "1" ? passwordText : (isEmailSelected ? emailText : phoneText),
            id: id,
            didEndEditing: true
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
            didEndEditing: true
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
            didEndEditing: false
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
            didEndEditing: true
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
            didEndEditing: false
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
            didEndEditing: false
        )
    }
}
