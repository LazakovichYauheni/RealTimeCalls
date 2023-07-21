import UIKit

final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    enum Direction {
        case present
        case dismiss
    }
    
    weak var mainScreenCell: MainScreenCollectionViewCell?
    weak var userDetailsScreenView: UserDetailsScreenView?
    var direction = Direction.present
    var duration: TimeInterval = 0.5
    var animate: (@escaping () -> Void) -> Void = { $0() }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let mainScreenCell = mainScreenCell,
            let userDetailsScreenView = userDetailsScreenView
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        if userDetailsScreenView.superview == nil {
            transitionContext.containerView.addSubview(userDetailsScreenView)
            userDetailsScreenView.frame = transitionContext.containerView.bounds
        }
        
        var transition: SnapshotTransition? = nil
        switch direction {
        case .present:
            mainScreenCell.callIconView.setIconVisibilityAnimated(isHidden: true)
            transition = SnapshotTransition(
                from: mainScreenCell,
                to: userDetailsScreenView,
                in: transitionContext.containerView,
                childTransitions: [
                    (from: mainScreenCell.iconImageView, to: userDetailsScreenView.iconImageView),
                    (from: mainScreenCell.titleLabel, to: userDetailsScreenView.titleLabel),
                    (from: mainScreenCell.descriptionLabel, to: userDetailsScreenView.descriptionLabel),
                    (from: mainScreenCell.callIconView, to: userDetailsScreenView.contentView)
                ],
                duration: duration
            )
            transition?.animationCompletion = {
                transitionContext.completeTransition(true)
            }
        case .dismiss:
            transition = SnapshotTransition(
                from: userDetailsScreenView,
                to: mainScreenCell,
                in: transitionContext.containerView,
                childTransitions: [
                    (from: userDetailsScreenView.iconImageView, to: mainScreenCell.iconImageView),
                    (from: userDetailsScreenView.titleLabel, to: mainScreenCell.titleLabel),
                    (from: userDetailsScreenView.descriptionLabel, to: mainScreenCell.descriptionLabel),
                    (from: userDetailsScreenView.contentView, to: mainScreenCell.callIconView)
                ],
                duration: duration
            )
            transition?.animationCompletion = {
                mainScreenCell.callIconView.setIconVisibilityAnimated(isHidden: false)
                transitionContext.completeTransition(true)
            }
        }
        
        transition?.prepare()
        
        animate {
            transition?.addKeyframes()
        }
    }
}
