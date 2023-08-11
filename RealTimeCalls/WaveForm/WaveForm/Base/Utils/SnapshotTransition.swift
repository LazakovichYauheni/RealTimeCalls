import UIKit

class SnapshotTransition {
    // MARK: Private

    private let fromView: UIView
    private let toView: UIView
    private let containerView: UIView
    private let transitionView: UIView
    private let childTransitions: [SnapshotTransition]
    private var fromViewAlpha: CGFloat = 1
    private var toViewAlpha: CGFloat = 1
    private var fromSnapshot: UIView?
    private var toSnapshot: UIView?
    private let duration: TimeInterval
    
    var animationCompletion: (() -> Void)?

    init(from: UIView,
         to: UIView,
         in container: UIView,
         clipToBounds: Bool = true,
         childTransitions: [(from: UIView, to: UIView)] = [],
         duration: TimeInterval
    ) {
        self.fromView = from
        self.toView = to
        self.containerView = container
        let transitionView = UIView(frame: .zero)
        transitionView.clipsToBounds = clipToBounds
        self.transitionView = transitionView
        self.duration = duration
        self.childTransitions = childTransitions.map {
            SnapshotTransition(from: $0.from, to: $0.to, in: transitionView, clipToBounds: true, duration: duration)
        }
    }

    func prepare() {
        let layerCornerRadiuses = [fromView, toView].map { ($0.layer, $0.layer.cornerRadius) }
        let childAlphas = childTransitions.flatMap { [$0.fromView, $0.toView] }.map { ($0, $0.alpha) }

        layerCornerRadiuses.forEach { layer, _ in layer.cornerRadius = 0 }
        childAlphas.forEach { view, _ in view.alpha = 0 }
        
        toSnapshot = toView.snapshotImageView()
        fromSnapshot = fromView.snapshotImageView()
        
        layerCornerRadiuses.forEach { layer, radius in layer.cornerRadius = radius }
        childAlphas.forEach { view, alpha in view.alpha = alpha }

        [fromSnapshot, toSnapshot].compactMap { $0 }.forEach {
            transitionView.addSubview($0)
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.frame = transitionView.bounds
        }

        fromViewAlpha = fromView.alpha
        toViewAlpha = toView.alpha

        fromSnapshot?.alpha = 1
        toSnapshot?.alpha = 0
        fromView.alpha = 0
        toView.alpha = 0

        transitionView.layer.cornerRadius = fromView.layer.cornerRadius
        transitionView.frame = fromView.convert(fromView.bounds, to: containerView)
        containerView.addSubview(transitionView)

        childTransitions.forEach { $0.prepare() }
    }

    func addKeyframes() {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.toSnapshot?.alpha = 1
            self.fromSnapshot?.alpha = 0
            self.transitionView.layer.cornerRadius = self.toView.layer.cornerRadius
            self.transitionView.frame = self.toView.convert(self.toView.bounds, to: self.transitionView.superview)
        }
        
        animator.addCompletion { position in
            self.cleanUp()
            animator.stopAnimation(true)
            self.animationCompletion?()
        }
        
        animator.startAnimation()
        
        childTransitions.forEach { $0.addKeyframes() }
    }

    func cleanUp() {
        toView.alpha = toViewAlpha
        fromView.alpha = fromViewAlpha
        transitionView.removeFromSuperview()
        fromSnapshot?.removeFromSuperview()
        toSnapshot?.removeFromSuperview()
        fromSnapshot = nil
        toSnapshot = nil
        childTransitions.forEach { $0.cleanUp() }
    }
}

extension UIView {
    func snapshotImageView() -> UIImageView? {
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        layer.render(in: context)

        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return UIImageView(image: viewImage, highlightedImage: viewImage)
    }
}
