import Foundation
import UIKit

public final class CallsInteractor {
    
    private let presenter: CallsPresenter
    private let title: String
    private let service: UserServiceProtocol
    
    public init(title: String, presenter: CallsPresenter, service: UserServiceProtocol) {
        self.title = title
        self.presenter = presenter
        self.service = service
    }
}

extension CallsInteractor {
    func obtainInitialState() {
        presenter.presentInitialState(title: title)
    }
}
