import Foundation
import UIKit

public final class CallsPresenter {
    weak var viewController: CallViewController?
}

extension CallsPresenter {
    func presentInitialState(title: String) {
        viewController?.display(title: title)
    }
}
