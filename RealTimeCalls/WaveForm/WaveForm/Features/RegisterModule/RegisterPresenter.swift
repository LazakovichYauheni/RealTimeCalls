//
//  LoginPresenter.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation

public final class RegisterPresenter {
    weak var viewController: RegisterViewController?
}

extension RegisterPresenter {
    func presentInitialState() {
        viewController?.display(
            viewModel: RegisterView.ViewModel(
                title: "Hi there!",
                description: "To use our app, you should to \nregister first",
                registerButtonTitle: "Register",
                fieldsViewModel: FieldsView.ViewModel(
                    textFieldViewModels: makeTextFields(
                        username: nil,
                        password: nil,
                        phone: nil,
                        firstName: nil,
                        lastName: nil,
                        isInvalidInputs: false
                    )
                ),
                isRegisterButtonEnabled: false,
                didEndEditing: false,
                selectedFieldID: .zero
            )
        )
    }
    
    func present(
        didEndEditing: Bool,
        username: String?,
        password: String?,
        phone: String?,
        firstName: String?,
        lastName: String?,
        isInvalidCredentials: Bool,
        selectedFieldID: Int
    ) {
        viewController?.display(
            viewModel: RegisterView.ViewModel(
                title: "Hi there!",
                description: "To use our app, you should to \nregister first",
                registerButtonTitle: "Register",
                fieldsViewModel: FieldsView.ViewModel(
                    textFieldViewModels: makeTextFields(
                        username: username,
                        password: password,
                        phone: phone,
                        firstName: firstName,
                        lastName: lastName,
                        isInvalidInputs: isInvalidCredentials
                    )
                ),
                isRegisterButtonEnabled: checkIsRegisterButtonEnabled(username: username, password: password, phone: phone),
                didEndEditing: didEndEditing,
                selectedFieldID: selectedFieldID
            )
        )
    }
    
    private func makeTextFields(
        username: String?,
        password: String?,
        phone: String?,
        firstName: String?,
        lastName: String?,
        isInvalidInputs: Bool
    ) -> [FloatingTextFieldView.ViewModel] {
        return [
            makeTextFieldForUsername(text: username, isInvalid: isInvalidInputs),
            makeTextFieldForPassword(text: password, isInvalid: isInvalidInputs),
            makeTextFieldForPhone(text: phone, isInvalid: isInvalidInputs),
            makeTextFieldForFirstName(text: firstName),
            makeTextFieldForLastName(text: lastName)
        ]
    }
    
    private func makeTextFieldForUsername(text: String?, isInvalid: Bool) -> FloatingTextFieldView.ViewModel {
        FloatingTextFieldView.ViewModel(
            textField: FloatingTextField.ViewModel(
                title: "Username",
                id: "0",
                text: text
            ),
            isInvalidInput: isInvalid,
            isNeedToShowClearButton: checkTextToShowClearButton(text: text)
        )
    }
    
    private func makeTextFieldForPassword(text: String?, isInvalid: Bool) -> FloatingTextFieldView.ViewModel {
        FloatingTextFieldView.ViewModel(
            textField: FloatingTextField.ViewModel(
                title: "Password",
                id: "1",
                text: text,
                isSecureTextEntry: true
            ),
            isInvalidInput: isInvalid,
            isNeedToShowClearButton: checkTextToShowClearButton(text: text)
        )
    }
    
    private func makeTextFieldForPhone(text: String?, isInvalid: Bool) -> FloatingTextFieldView.ViewModel {
        FloatingTextFieldView.ViewModel(
            textField: FloatingTextField.ViewModel(
                title: "Phone number",
                id: "2",
                text: text
            ),
            isInvalidInput: isInvalid,
            isNeedToShowClearButton: checkTextToShowClearButton(text: text)
        )
    }
    
    private func makeTextFieldForFirstName(text: String?) -> FloatingTextFieldView.ViewModel {
        FloatingTextFieldView.ViewModel(
            textField: FloatingTextField.ViewModel(
                title: "First name(optional)",
                id: "3",
                text: text
            ),
            isInvalidInput: false,
            isNeedToShowClearButton: checkTextToShowClearButton(text: text)
        )
    }
    
    private func makeTextFieldForLastName(text: String?) -> FloatingTextFieldView.ViewModel {
        FloatingTextFieldView.ViewModel(
            textField: FloatingTextField.ViewModel(
                title: "Last name(optional)",
                id: "4",
                text: text
            ),
            isInvalidInput: false,
            isNeedToShowClearButton: checkTextToShowClearButton(text: text)
        )
    }
    
    private func checkTextToShowClearButton(text: String?) -> Bool {
        guard let text = text else { return false }
        return !text.isEmpty
    }
    
    private func checkIsRegisterButtonEnabled(username: String?, password: String?, phone: String?) -> Bool {
        guard
            let username = username?.replacingOccurrences(of: " ", with: ""),
            let password = password?.replacingOccurrences(of: " ", with: ""),
            let phone = phone?.replacingOccurrences(of: " ", with: "")
        else { return false }
        return !username.isEmpty && !password.isEmpty && !phone.isEmpty
    }
    
    func presentMainScreen() {
        viewController?.displayMainScreen()
    }
}
