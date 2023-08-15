//
//  UIView+Extensions.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 14.03.23.
//

import UIKit

extension UIView {
    func blur(blurStyle: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = 0.75

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}

extension UIView{
    func rotate(duration: CFTimeInterval = 1) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotating() {
        self.layer.removeAllAnimations()
    }
}

extension UIView {
    /// Добавляет ангулар градиент с анимацией на круглую вью
    func addGradientBorder(to view: UIView, lineWidth: CGFloat) {
        let path = UIBezierPath(ovalIn: view.bounds.insetBy(dx: 1, dy: 1))

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.type = .conic
        gradient.colors = Color.current.google.googleColors.compactMap { $0.cgColor }

        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = path.cgPath
        shape.strokeColor = Color.current.background.blackColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        view.layer.addSublayer(gradient)
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0
        anim.toValue = Double.pi * 2
        anim.duration = 3
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        gradient.add(anim, forKey: "sss")
    }
    
    /// параллакс эффект
    func addParallaxToView(vw: UIView) {
        let amount = 20

        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = 0

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
    
    func setShimmeringAnimation(_ animate: Bool, viewBackgroundColor: UIColor? = nil, animationSpeed: CGFloat) {
            let baseShimmeringColor: UIColor? = viewBackgroundColor ?? superview?.backgroundColor
            guard let color = baseShimmeringColor else {
                print("⚠️ Warning: `viewBackgroundColor` can not be nil while calling `setShimmeringAnimation`")
                return
            }

            // MARK: - Shimmering Layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = min(bounds.height / 2, 5)
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            let gradientColorOne = color.withAlphaComponent(0.5).cgColor
            let gradientColorTwo = color.withAlphaComponent(0.8).cgColor
            gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
            gradientLayer.locations = [0.0, 0.5, 1.0]
            layer.addSublayer(gradientLayer)
            gradientLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude)

            // MARK: - Shimmer Animation
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = [-1.0, -0.5, 0.0]
            animation.toValue = [1.0, 1.5, 2.0]
            animation.repeatCount = .infinity
            animation.duration = animationSpeed
            gradientLayer.add(animation, forKey: animation.keyPath)
        }
}
