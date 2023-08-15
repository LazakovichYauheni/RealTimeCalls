import UIKit

final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    enum Direction {
        case present
        case dismiss
    }
    
    weak var fromView: UIView?
    weak var toView: UIView?
    
    var direction = Direction.present
    var duration: TimeInterval = 0.5
    var animate: (@escaping () -> Void) -> Void = { $0() }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = fromView,
            let toView = toView
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        if toView.superview == nil {
            transitionContext.containerView.addSubview(toView)
            toView.frame = transitionContext.containerView.bounds
        }
        
        var transition: SnapshotTransition? = nil
        switch direction {
        case .present:
            if
                let cell = fromView as? MainScreenCollectionViewCell,
                let detailsScreenView = toView as? UserDetailsScreenView {
                cell.callIconView.setIconVisibilityAnimated(isHidden: true)
                
                transition = SnapshotTransition(
                    from: cell,
                    to: detailsScreenView,
                    in: transitionContext.containerView,
                    childTransitions: [
                        (from: cell.iconImageView, to: detailsScreenView.headerView.iconImageView),
                        (from: cell.callIconView, to: detailsScreenView.contentView)
                    ],
                    duration: duration
                )
            } else if
                let cell = fromView as? ContactTableViewCell,
                let detailsScreenView = toView as? UserDetailsScreenView {
                transition = SnapshotTransition(
                    from: cell,
                    to: detailsScreenView,
                    in: transitionContext.containerView,
                    childTransitions: [
                        (from: cell.iconImageView, to: detailsScreenView.headerView.iconImageView),
                        (from: cell.containerView, to: detailsScreenView.contentView)
                    ],
                    duration: duration
                )
            }
            transition?.animationCompletion = {
                transitionContext.completeTransition(true)
            }
        case .dismiss:
            if
                let cell = fromView as? MainScreenCollectionViewCell,
                let detailsScreenView = toView as? UserDetailsScreenView {
                transition = SnapshotTransition(
                    from: detailsScreenView,
                    to: cell,
                    in: transitionContext.containerView,
                    childTransitions: [
                        (from: detailsScreenView.headerView.iconImageView, to: cell.iconImageView),
                        (from: detailsScreenView.contentView, to: cell.callIconView)
                    ],
                    duration: duration
                )
                transition?.animationCompletion = {
                    cell.callIconView.setIconVisibilityAnimated(isHidden: false)
                    transitionContext.completeTransition(true)
                }
            } else if
                let cell = fromView as? ContactTableViewCell,
                let detailsScreenView = toView as? UserDetailsScreenView {
                transition = SnapshotTransition(
                    from: detailsScreenView,
                    to: cell,
                    in: transitionContext.containerView,
                    childTransitions: [
                        (from: detailsScreenView.headerView.iconImageView, to: cell.iconImageView),
                        (from: detailsScreenView.contentView, to: cell.containerView)
                    ],
                    duration: duration
                )
                transition?.animationCompletion = {
                    transitionContext.completeTransition(true)
                }
            }
        }
        
        transition?.prepare()
        
        animate {
            transition?.addKeyframes()
        }
    }
}
