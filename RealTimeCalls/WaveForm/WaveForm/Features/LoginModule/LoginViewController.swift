//
//  LoginViewController.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation
import UIKit
import NotificationBannerSwift

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
    
    func showAlert(error: UIError) {
        let banner = FloatingNotificationBanner(subtitle: error.description, subtitleTextAlign: .center, style: .danger)
        banner.autoDismiss = true
        banner.show(
            cornerRadius: spacer.space12,
            shadowColor: UIColor(red: 0, green: 31 / 255, blue: 61 / 255, alpha: 0.04),
            shadowBlurRadius: spacer.space16
        )
    }
    
    func pushMainScreen(user: User) {
        let mainScreenViewController = MainScreenAssembly().assemble(user: user)
        navigationController?.pushViewController(mainScreenViewController, animated: true)
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

// MARK: - LoginViewEventsRespondable

extension LoginViewController: LoginViewEventsRespondable {
    public func loginTapped() {
        //interactor.obtainLogin()
        
        pushMainScreen(
            user: User(
                dto: UserDTO(
                    id: "12341234",
                    username: "user",
                    password: "1234",
                    firstName: "YA",
                    lastName: "ETO",
                    phoneNumber: "",
                    contacts: [
                        ContactDTO(
                            id: "1",
                            firstName: "loh",
                            lastName: "ftgsv",
                            phoneNumber: "123456789",
                            isFavorite: true
                        ),
                        ContactDTO(
                            id: "2",
                            firstName: "ty",
                            lastName: "ftgsv",
                            phoneNumber: "123456789",
                            isFavorite: true
                        ),
                        ContactDTO(
                            id: "3",
                            firstName: "ebany",
                            lastName: "ftgsv",
                            phoneNumber: "123456789",
                            isFavorite: true
                        ),
                        ContactDTO(
                            id: "4",
                            firstName: "debik",
                            lastName: "ftgsv",
                            phoneNumber: "123456789",
                            isFavorite: true
                        )
                    ],
                    recentContacts: [],
                    favoritesContacts: []
                )
            )
        )
    }
}
