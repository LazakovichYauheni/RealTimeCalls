//
//  MainScreenInteractor.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 23.06.23.
//

import Foundation

public final class MainScreenInteractor {
    private let presenter: MainScreenPresenter
    private let user: User
    
    public init(
        presenter: MainScreenPresenter,
        user: User
    ) {
        self.presenter = presenter
        self.user = user
    }
}

extension MainScreenInteractor {
    func obtainInitialState() {
        presenter.present(user: user)
    }
    
    func obtainAllContacts() {
        presenter.presentAll(contacts: user.contacts)
    }
}
