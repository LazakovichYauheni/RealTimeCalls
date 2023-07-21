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
    func assemble(user: User) -> MainScreenViewController {
        let presenter = MainScreenPresenter()
        let interactor = MainScreenInteractor(presenter: presenter, user: user)

        let viewController = MainScreenViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
