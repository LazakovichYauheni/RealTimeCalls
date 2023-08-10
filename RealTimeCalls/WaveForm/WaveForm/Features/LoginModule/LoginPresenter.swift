//
//  LoginPresenter.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation

public final class LoginPresenter {
    weak var viewController: LoginViewController?
}

extension LoginPresenter {
    func presentInitialState() {
        viewController?.display(
            viewModel: LoginView.ViewModel(
                title: "Welcome Back",
                description: "To use your account, \nyou should log in first",
                loginButtonTitle: "Login",
                filterViewModel: FilterView.ViewModel(filterState: .username),
                fieldsViewModel: FieldsView.ViewModel(
                    textFieldViewModels: userNameTextFields(username: nil, password: nil, isInvalid: false)
                ),
                isLoginButtonEnabled: false,
                didEndEditing: false
            )
        )
    }
    
    func present(
        didEndEditing: Bool,
        state: FilterSelectionState,
        firstFieldText: String?,
        passwordText: String?,
        isInvalidCredentials: Bool
    ) {
        viewController?.display(
            viewModel: LoginView.ViewModel(
                title: "Welcome Back",
                description: "To use your account, \nyou should log in first",
                loginButtonTitle: "Login",
                filterViewModel: FilterView.ViewModel(filterState: state),
                fieldsViewModel: FieldsView.ViewModel(
                    textFieldViewModels: state == .username
                        ? userNameTextFields(username: firstFieldText, password: passwordText, isInvalid: isInvalidCredentials)
                        : phoneTextFields(phoneNumber: firstFieldText, password: passwordText, isInvalid: isInvalidCredentials)
                ),
                isLoginButtonEnabled: checkIsLoginButtonEnabled(firstText: firstFieldText, password: passwordText),
                didEndEditing: didEndEditing
            )
        )
    }
    
    private func userNameTextFields(username: String?, password: String?, isInvalid: Bool) -> [FloatingTextFieldView.ViewModel] {
        return [
            makeTextFieldForUsername(text: username, isInvalid: isInvalid),
            makeTextFieldForPassword(text: password, isInvalid: isInvalid)
        ]
    }
    
    private func phoneTextFields(phoneNumber: String?, password: String?, isInvalid: Bool) -> [FloatingTextFieldView.ViewModel] {
        return [
            makeTextFieldForPhone(text: phoneNumber, isInvalid: isInvalid),
            makeTextFieldForPassword(text: password, isInvalid: isInvalid)
        ]
    }
    
    private func makeTextFieldForUsername(text: String?, isInvalid: Bool) -> FloatingTextFieldView.ViewModel {
        FloatingTextFieldView.ViewModel(
            textField: FloatingTextField.ViewModel(title: "Username", id: "0", text: text),
            isInvalidInput: isInvalid,
            isNeedToShowClearButton: checkIsNeedClearButton(text: text)
        )
    }
    
    private func makeTextFieldForPhone(text: String?, isInvalid: Bool) -> FloatingTextFieldView.ViewModel {
        FloatingTextFieldView.ViewModel(
            textField: FloatingTextField.ViewModel(title: "Phone number", id: "0", text: text),
            isInvalidInput: isInvalid,
            isNeedToShowClearButton: checkIsNeedClearButton(text: text)
        )
    }
    
    private func makeTextFieldForPassword(text: String?, isInvalid: Bool) -> FloatingTextFieldView.ViewModel {
        FloatingTextFieldView.ViewModel(
            textField: FloatingTextField.ViewModel(title: "Password", id: "1", text: text, isSecureTextEntry: true),
            isInvalidInput: isInvalid,
            isNeedToShowClearButton: checkIsNeedClearButton(text: text)
        )
    }
    
    private func checkIsNeedClearButton(text: String?) -> Bool {
        guard let text = text else { return false }
        return !text.isEmpty
    }
    
    private func checkIsLoginButtonEnabled(firstText: String?, password: String?) -> Bool {
        guard
            let firstText = firstText,
            let password = password
        else { return false }
        return !firstText.isEmpty && !password.isEmpty
    }
    
    func showAlert(error: UIError) {
        viewController?.showAlert(error: error)
    }
    
    func presentMainScreen() {
        viewController?.pushMainScreen()
    }
}
