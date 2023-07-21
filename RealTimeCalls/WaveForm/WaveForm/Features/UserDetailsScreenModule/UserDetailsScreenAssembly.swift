import Foundation
import UIKit

protocol UserDetailsScreenAssemblyProtocol {
    func assemble() -> LoginViewController
}

public final class UserDetailsScreenAssembly {
    func assemble(
        data: MainScreenCollectionViewCell.ViewModel
    ) -> UserDetailsScreenViewController {
        let presenter = UserDetailsScreenPresenter()
        let dismisser = TransitionDismisser()
        let interactor = UserDetailsScreenInteractor(
            presenter: presenter,
            data: data
        )

        let viewController = UserDetailsScreenViewController(
            interactor: interactor,
            dismisser: dismisser
        )
        presenter.viewController = viewController
        
        return viewController
    }
}

