import UIKit

final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    enum Direction {
        case present
        case dismiss
    }
    
//    weak var mainScreenCell: MainScreenCollectionViewCell?
//    weak var userDetailsScreenView: UserDetailsScreenView?
    
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
                        (from: cell.iconImageView, to: detailsScreenView.iconImageView),
                        (from: cell.titleLabel, to: detailsScreenView.titleLabel),
                        (from: cell.descriptionLabel, to: detailsScreenView.descriptionLabel),
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
                        (from: cell.iconImageView, to: detailsScreenView.iconImageView),
                        (from: cell.titleLabel, to: detailsScreenView.titleLabel),
                        (from: cell.descriptionLabel, to: detailsScreenView.descriptionLabel),
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
                        (from: detailsScreenView.iconImageView, to: cell.iconImageView),
                        (from: detailsScreenView.titleLabel, to: cell.titleLabel),
                        (from: detailsScreenView.descriptionLabel, to: cell.descriptionLabel),
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
                        (from: detailsScreenView.iconImageView, to: cell.iconImageView),
                        (from: detailsScreenView.titleLabel, to: cell.titleLabel),
                        (from: detailsScreenView.descriptionLabel, to: cell.descriptionLabel),
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
