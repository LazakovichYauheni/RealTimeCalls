//
//  LoginPresenter.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation

public final class LoginPresenter {
    weak var viewController: LoginViewController?

    lazy var emailTextFieldViewModel = FloatingTextFieldView.ViewModel(
        textField: FloatingTextField.ViewModel(
            title: "Email",
            id: "0"
        ),
        isInvalidInput: false,
        isNeedToShowClearButton: false
    )
    
    lazy var passwordTextFieldViewModel = FloatingTextFieldView.ViewModel(
        textField: FloatingTextField.ViewModel(
            title: "Password",
            id: "1"
        ),
        isInvalidInput: false,
        isNeedToShowClearButton: false
    )
    
    lazy var phoneTextFieldViewModel = FloatingTextFieldView.ViewModel(
        textField: FloatingTextField.ViewModel(
            title: "Phone number",
            id: "0"
        ),
        isInvalidInput: false,
        isNeedToShowClearButton: false
    )
    
    lazy var emailTextFields: [FloatingTextFieldView.ViewModel] = [
        emailTextFieldViewModel,
        passwordTextFieldViewModel,
    ]
    
    lazy var phoneTextFields: [FloatingTextFieldView.ViewModel] = [
        phoneTextFieldViewModel,
        passwordTextFieldViewModel
    ]
    
    private func makeEmailTextFields(text: String?, id: String, didEndEditing: Bool) -> [FloatingTextFieldView.ViewModel] {
        guard
            let index = emailTextFields.firstIndex(where: { $0.textField.id == id })
        else { return [] }
        emailTextFields[index] = FloatingTextFieldView.ViewModel(
            textField: FloatingTextField.ViewModel(
                title: emailTextFields[index].textField.title,
                id: emailTextFields[index].textField.id,
                text: text
            ),
            mask: id == "1" ? nil : FloatingTextFieldMask(isCharactersOnlyUppercased: false),
            isInvalidInput: id == "0" ? ((!(text?.isEmpty ?? true)) && !(text?.contains("@") ?? true)) : false,
            isNeedToShowClearButton: !didEndEditing
        )
        return emailTextFields
    }
    
    private func makePhoneTextFields(text: String?,id: String, didEndEditing: Bool) -> [FloatingTextFieldView.ViewModel] {
        guard
            let index = phoneTextFields.firstIndex(where: { $0.textField.id == id })
        else { return [] }
        phoneTextFields[index] = FloatingTextFieldView.ViewModel(
            textField: FloatingTextField.ViewModel(
                title: phoneTextFields[index].textField.title,
                id: phoneTextFields[index].textField.id,
                text: text
            ),
            mask: id == "1" ? nil : FloatingTextFieldMask(
                mask: "+375 (XX) XXX-XX-XX",
                isCharactersOnlyUppercased: false,
                validCharacters: getValidPhoneCharacters()
            ),
            isInvalidInput: false,
            isNeedToShowClearButton: !didEndEditing
        )
        return phoneTextFields
    }
    
    private func getValidPhoneCharacters() -> [Character: Character] {
        [
            "1": "1",
            "2": "2",
            "3": "3",
            "4": "4",
            "5": "5",
            "6": "6",
            "7": "7",
            "8": "8",
            "9": "9",
            "0": "0",
            "(": "(",
            ")": ")",
            "-": "-",
            "+": "+",
            " ": " "
        ]
    }
    
    private func checkEmailFields() -> Bool {
        guard
            let emailText = emailTextFields[0].textField.text,
            let passwordText = emailTextFields[1].textField.text,
            emailText != "",
            emailText.contains("@"),
            passwordText != ""
        else { return false }
        return true
    }
    
    private func checkPhoneFields() -> Bool {
        guard
            let phoneText = phoneTextFields[0].textField.text,
            let passwordText = phoneTextFields[1].textField.text,
            phoneText != "",
            passwordText != ""
        else { return false }
        return true
    }
}

extension LoginPresenter {
    func presentInitialState(
        isEmailSelected: Bool,
        isInitialState: Bool,
        text: String?,
        id: String,
        didEndEditing: Bool
    ) {
        viewController?.display(
            viewModel: LoginView.ViewModel(
                title: "Welcome Back",
                description: "To use your account,\nyou should log in first",
                filterViewModel: FilterView.ViewModel(
                    isEmailSelected: isEmailSelected,
                    isInitialState: isInitialState
                ),
                fieldsViewModel: FieldsView.ViewModel(
                    textFieldViewModels: isEmailSelected
                        ? makeEmailTextFields(text: text, id: id, didEndEditing: didEndEditing)
                        : makePhoneTextFields(text: text, id: id, didEndEditing: didEndEditing)
                ),
                isLoginButtonEnabled: isEmailSelected ? checkEmailFields() : checkPhoneFields(),
                didEndEditing: didEndEditing
            )
        )
    }
}
