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
    private let username: String
    private let token: String
    private var user: User?
    
    public init(
        presenter: MainScreenPresenter,
        service: UserServiceProtocol,
        username: String,
        token: String
    ) {
        self.presenter = presenter
        self.service = service
        self.username = username
        self.token = token
    }
}

extension MainScreenInteractor {
    func obtainInitialState() {
        service.getUserData(username: username, token: token) { [weak self] result in
            switch result {
            case let .success(user):
                self?.presenter.present(user: user)
            case .failure:
                print("error")
            }
        }
    }
    
    func obtainAllContacts() {
        guard let user = user else { return }
        presenter.presentAll(contacts: user.contacts)
    }
}
