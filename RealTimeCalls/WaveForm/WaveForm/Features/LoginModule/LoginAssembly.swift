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
        
        let requestManager = RequestManager()
        let endpointConfig = EndpointConfig()
        let service = UserService(requestManager: requestManager, endpointConfig: endpointConfig)
        let presenter = LoginPresenter()
        let interactor = LoginInteractor(presenter: presenter, service: service)
        
        
        
        let viewController = LoginViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
