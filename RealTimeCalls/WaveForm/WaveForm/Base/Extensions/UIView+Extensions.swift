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
    func addGradientBorder(to view: UIView) {
        let path = UIBezierPath(ovalIn: view.bounds.insetBy(dx: 1, dy: 1))

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.type = .conic
        gradient.colors = Color.current.google.googleColors.compactMap { $0.cgColor }

        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = path.cgPath
        shape.strokeColor = Color.current.background.blackColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        view.layer.insertSublayer(gradient, at: 0)
        
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
}
