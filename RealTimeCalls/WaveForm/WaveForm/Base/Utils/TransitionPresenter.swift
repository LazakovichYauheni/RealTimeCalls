import UIKit

class TransitionPresenter: NSObject, UIViewControllerTransitioningDelegate {
    private let transition = TransitionManager()
    private var duration: TimeInterval = .zero
    private var data: MainScreenCollectionViewCell.ViewModel?
    
    public override init() {
        super.init()
    }
    

    // MARK: ProductPresenting

    func present(_ data: MainScreenCollectionViewCell.ViewModel, from presenting: UIViewController, duration: TimeInterval) {
        let viewController = UserDetailsScreenAssembly().assemble(data: data)
        self.duration = duration
        self.data = data
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.transitioningDelegate = self
        presenting.present(viewController, animated: true)
    }

    // MARK: UIViewControllerTransitioningDelegate

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        transition.direction = .present
        transition.duration = duration
        if let mainScreenVC = source as? MainScreenViewController {
            transition.fromView = mainScreenVC.currentCell
        }
        
        if let contactsVC = source as? AllContactsViewController {
            transition.fromView = contactsVC.currentCell
        }
        
        transition.toView = (presented as? UserDetailsScreenViewController)?.view as? UserDetailsScreenView
        return transition
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        transition.direction = .dismiss
        transition.duration = duration
        return transition
    }
}

