//
//  MainScreenAssembly.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation

protocol MainScreenAssemblyProtocol {
    func assemble() -> LoginViewController
}

public final class MainScreenAssembly {
    func assemble() -> MainScreenViewController {
        let presenter = MainScreenPresenter()
        let requestManager = RequestManager()
        let endpointConfig = EndpointConfig()
        let service = UserService(requestManager: requestManager, endpointConfig: endpointConfig)
        let interactor = MainScreenInteractor(presenter: presenter, service: service)

        let viewController = MainScreenViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
