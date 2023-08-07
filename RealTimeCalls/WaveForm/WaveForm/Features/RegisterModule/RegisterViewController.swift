//
//  RegisterViewController.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation
import UIKit
import NotificationBannerSwift
import GoogleSignIn

public final class RegisterViewController: UIViewController {
    
    private let interactor: RegisterInteractor
    private let contentView = RegisterView(frame: .zero)
    
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
        title = "Register"
        navigationController?.setNavigationBarHidden(false, animated: true)
        setNavigationBarTint(
            with: UIViewController.NavigationBarConfiguration(
                tintColor: Color.current.background.blackColor,
                barTintColor: Color.current.background.mainColor,
                textColor: Color.current.text.blackColor,
                isTranslucent: false,
                backgroundImage: UIImage(),
                shadowImage: UIImage()
            ),
            coordinatedTransition: false
        )
    }
    
    public init(interactor: RegisterInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
}

extension RegisterViewController {
    func display(viewModel: RegisterView.ViewModel) {
        contentView.configure(viewModel: viewModel)
    }
    
    func displayMainScreen(username: String, token: String) {
        let mainScreenViewController = MainScreenAssembly().assemble(username: username, token: token)
        navigationController?.pushViewController(mainScreenViewController, animated: true)
    }
    
    func showAlert(error: UIError) {
        let banner = FloatingNotificationBanner(subtitle: error.description, subtitleTextAlign: .center, style: .danger)
        banner.autoDismiss = true
        banner.show(
            cornerRadius: spacer.space12,
            shadowColor: Color.current.background.shadowColor,
            shadowBlurRadius: spacer.space16
        )
    }
}

// MARK: - RegisterViewEventsRespondable

extension RegisterViewController: RegisterViewEventsRespondable {
    public func registerTapped() {
        interactor.obtainRegister()
    }
    
    public func googleTapped() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard
                let result = result,
                let username = result.user.profile?.email
            else { return }
            self?.displayMainScreen(username: username, token: result.user.accessToken.tokenString)
        }
    }
}

// MARK: - ModernFloatingTextFieldEventsRespondable

extension RegisterViewController: FloatingTextFieldEventsRespondable {
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

// MARK: - FloatingTextFieldViewEventsRespondable

extension RegisterViewController: FloatingTextFieldViewEventsRespondable {
    public func tapRightIconButton(id: String) {
        interactor.obtainClearButton(id: id)
    }
}
