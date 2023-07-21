import Foundation
import UIKit

protocol AllContactsAssembyProtocol {
    func assemble() -> LoginViewController
}

public final class AllContactsAssemby {
    func assemble(contacts: [Contact]) -> AllContactsViewController {
        let presenter = AllContactsPresenter()
        let interactor = AllContactsInteractor(presenter: presenter, contacts: contacts)

        let viewController = AllContactsViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}

