//
//  MainScreenInteractor.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 23.06.23.
//

import Foundation

public final class MainScreenInteractor {
    private let presenter: MainScreenPresenter
    private let service: UserServiceProtocol
    private var user: User?
    
    public init(
        presenter: MainScreenPresenter,
        service: UserServiceProtocol
    ) {
        self.presenter = presenter
        self.service = service
    }
}

extension MainScreenInteractor {
    func obtainInitialState() {
        service.getUserData() { [weak self] result in
            switch result {
            case let .success(user):
                self?.presenter.present(user: user)
            case .failure:
                self?.presenter.presentEmpty()
            }
        }
    }
    
    func obtainAllContacts() {
        guard let user = user else {
            presenter.presentAll(contacts: [])
            return
        }
        presenter.presentAll(contacts: user.contacts)
    }
}
