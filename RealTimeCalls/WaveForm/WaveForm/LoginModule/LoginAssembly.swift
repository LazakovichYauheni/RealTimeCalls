//
//  LoginAssembly.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation

protocol LoginAssemblyProtocol {
    func assemble() -> LoginViewController
}

public final class LoginAssembly {
    func assemble() -> LoginViewController {
        
        let presenter = LoginPresenter()
        let interactor = LoginInteractor(presenter: presenter)
        
        let viewController = LoginViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
