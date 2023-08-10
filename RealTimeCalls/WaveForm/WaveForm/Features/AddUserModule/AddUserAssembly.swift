import Foundation
import UIKit

protocol AddUserAssemblyProtocol {
    func assemble() -> LoginViewController
}

public final class AddUserAssembly {
    func assemble() -> AddUserViewController {
        let presenter = AddUserPresenter()
        let interactor = AddUserInteractor(presenter: presenter)

        let viewController = AddUserViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}

