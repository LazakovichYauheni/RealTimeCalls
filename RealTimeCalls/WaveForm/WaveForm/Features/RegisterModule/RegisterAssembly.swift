//
//  RegisterAssembly.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation

protocol RegisterAssemblyProtocol {
    func assemble() -> RegisterViewController
}

public final class RegisterAssembly {
    func assemble() -> RegisterViewController {
        let requestManager = RequestManager()
        let endpointConfig = EndpointConfig()
        let service = UserService(requestManager: requestManager, endpointConfig: endpointConfig)
        let presenter = RegisterPresenter()
        let interactor = RegisterInteractor(presenter: presenter, service: service)
        
        let viewController = RegisterViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
