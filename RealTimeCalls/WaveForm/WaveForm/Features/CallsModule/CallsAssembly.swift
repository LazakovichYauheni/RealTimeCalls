import Foundation

protocol CallsAssemblyProtocol {
    func assemble(title: String) -> CallViewController
}

public final class CallsAssembly {
    func assemble(title: String) -> CallViewController {
        let presenter = CallsPresenter()
        let requestManager = RequestManager()
        let endpointConfig = EndpointConfig()
        let service = UserService(requestManager: requestManager, endpointConfig: endpointConfig)
        let interactor = CallsInteractor(title: title, presenter: presenter, service: service)
        
        let viewController = CallViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
