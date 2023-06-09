//
//  LoginViewController.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation
import UIKit

public final class LoginViewController: UIViewController {
    
    private let interactor: LoginInteractor
    private let contentView = LoginView(frame: .zero)
    
    public override func loadView() {
        super.loadView()
        view = contentView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.obtainInitialState()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        navigationController?.setNavigationBarHidden(false, animated: true)
        setNavigationBarTint(
            with: UIViewController.NavigationBarConfiguration(
                tintColor: .black,
                barTintColor: UIColor(red: 235 / 255, green: 241 / 255, blue: 245 / 255, alpha: 1),
                textColor: .black,
                isTranslucent: false,
                backgroundImage: UIImage(),
                shadowImage: UIImage()
            ),
            coordinatedTransition: false
        )
    }
    
    public init(interactor: LoginInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
}

extension LoginViewController {
    func display(viewModel: LoginView.ViewModel) {
        contentView.configure(viewModel: viewModel)
    }
}

// MARK: - ModernFloatingTextFieldEventsRespondable

extension LoginViewController: FloatingTextFieldEventsRespondable {
    public func textFieldDidBeginEditing(text: String, id: String) {
        interactor.obtainBeginEditing(text: text, id: id)
    }

    public func textFieldDidEndEditing(text: String, id: String) {
        interactor.obtainEndEditing(text: text, id: id)
    }

    public func textFieldDidChange(text: String, id: String) {
        interactor.obtainTextChanging(text: text, id: id)
    }
}

// MARK: - FilterViewEventsRespondable

extension LoginViewController: FilterViewEventsRespondable {
    public func emailTapped() {
        interactor.switchSegment(isEmailSelected: true, isInitialState: false)
    }
    
    public func phoneTapped() {
        interactor.switchSegment(isEmailSelected: false, isInitialState: false)
    }
}

// MARK: - FloatingTextFieldViewEventsRespondable

extension LoginViewController: FloatingTextFieldViewEventsRespondable {
    public func tapRightIconButton() {
        interactor.obtainClearButton()
    }
}
