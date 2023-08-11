import Foundation

protocol ProfileAssemblyProtocol {
    func assemble(user: User) -> ProfileViewController
}

public final class ProfileAssembly {
    func assemble(user: User) -> ProfileViewController {
        let presenter = ProfilePresenter()
        let requestManager = RequestManager()
        let endpointConfig = EndpointConfig()
        let service = UserService(requestManager: requestManager, endpointConfig: endpointConfig)
        let interactor = ProfileInteractor(user: user, presenter: presenter, service: service)
        
        let viewController = ProfileViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
