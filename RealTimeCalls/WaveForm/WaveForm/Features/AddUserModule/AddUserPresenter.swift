//
//  AddUserPresenter.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 4.08.23.
//

import Foundation
import UIKit

public final class AddUserPresenter {
    weak var viewController: AddUserViewController?
}

extension AddUserPresenter {
    func presentInitialState() {
        viewController?.display(viewModel: AddUserView.ViewModel(
            image: UIImage(named: "addUser") ?? UIImage(),
            textFieldViewModel: FloatingTextFieldView.ViewModel(
                textField: FloatingTextField.ViewModel(title: "Username", id: "0"),
                isInvalidInput: false,
                isNeedToShowClearButton: false
            ),
            contactViewModels: [],
            isInitialState: true
        ))
    }
    
    func present(text: String, isSuccessButtonNeeded: Bool, isLoaderNeeded: Bool, contacts: [String]) {
        viewController?.display(
            viewModel: AddUserView.ViewModel(
                image: UIImage(named: "addUser") ?? UIImage(),
                textFieldViewModel: FloatingTextFieldView.ViewModel(
                    textField: FloatingTextField.ViewModel(title: "Username", id: "0", text: text),
                    isInvalidInput: false,
                    isNeedToShowClearButton: checkIsNeedClearButton(text: text),
                    isNeedToShowSuccessButton: isSuccessButtonNeeded,
                    isNeedToShowLoader: isLoaderNeeded
                ),
                contactViewModels: makeContactViewModels(contacts: contacts),
                isInitialState: false
            )
        )
    }
    
    func presentSuccessAlert(string: String) {
        viewController?.showAlert(string: string)
    }
    
    private func checkIsNeedClearButton(text: String) -> Bool {
        return !text.isEmpty
    }
    
    private func makeContactViewModels(contacts: [String]) -> [ContactCell.ViewModel] {
        contacts.compactMap {
            return ContactCell.ViewModel(text: $0)
        }
    }
}
