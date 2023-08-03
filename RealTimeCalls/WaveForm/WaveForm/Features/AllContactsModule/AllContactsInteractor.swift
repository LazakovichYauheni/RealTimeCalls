//
//  MainScreenInteractor.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 23.06.23.
//

import Foundation
import UIKit

public final class AllContactsInteractor {
    private let presenter: AllContactsPresenter
    private let contacts: [Contact]
    
    public init(
        presenter: AllContactsPresenter,
        contacts: [Contact]
    ) {
        self.presenter = presenter
        self.contacts = contacts
    }
}

extension AllContactsInteractor {
    func obtainInitialState() {
        presenter.present(contacts: contacts)
    }
    
    func obtainSelectedCell(index: Int) {
        guard let contact = contacts[safe: index] else { return }
        presenter.presentSelectedCell(contact: contact)
    }
}

