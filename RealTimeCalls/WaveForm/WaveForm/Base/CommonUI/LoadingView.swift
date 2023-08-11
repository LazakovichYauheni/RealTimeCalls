import UIKit

private enum Constants {
    static let animationDuration: TimeInterval = 1
    static let animationKey = "backgroundColorAnimation"
    static let backgroundAnimationKeyPath = "backgroundColor"
}

final class LoadingView: UIView {
    // MARK: - Private Properties

    private var darkColor: UIColor?
    private var lightColor: UIColor?

    // MARK: - UIView

    override public init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Public Methods

    public func startAnimation() {
        stopAnimation()
        let animation = CABasicAnimation(keyPath: Constants.backgroundAnimationKeyPath)
        animation.fromValue = darkColor?.cgColor
        animation.toValue = lightColor?.cgColor
        animation.duration = Constants.animationDuration
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false

        layer.add(animation, forKey: Constants.animationKey)
    }

    public func stopAnimation() {
        layer.removeAnimation(forKey: Constants.animationKey)
    }

    func commonInit() {
        guard UIView.areAnimationsEnabled else { return }
        darkColor = Color.current.background.darkGrayColor
        lightColor = Color.current.background.lightGrayColor
        backgroundColor = lightColor
        startAnimation()
    }
}

