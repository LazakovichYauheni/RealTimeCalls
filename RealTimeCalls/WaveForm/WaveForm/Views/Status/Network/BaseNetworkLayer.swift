//
//  BaseNetworkLayer.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 14.03.23.
//

import UIKit

public final class BaseNetworkLayer: CAShapeLayer {
    private var layerHeight: CGFloat = .zero
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public init(color: UIColor, height: CGFloat) {
        super.init()
        
        layerHeight = height
        fillColor = color.cgColor
        cornerRadius = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSublayers() {
        super.layoutSublayers()
        
        let rect = CGRect(x: .zero, y: .zero, width: self.bounds.width, height: layerHeight)
        let bez = UIBezierPath(roundedRect: rect, cornerRadius: 2)
        path = bez.cgPath
    }
    
    var completion: (() -> Void)?
    
    func animate(height: CGFloat, completion: @escaping () -> Void) {
        let oldPath = self.path
        let newPath = UIBezierPath(roundedRect: CGRect(
            x: .zero,
            y: .zero,
            width: self.bounds.width,
            height: height
        ), cornerRadius: 2)
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.beginTime = 0
        animation.fromValue = oldPath
        animation.toValue = newPath.cgPath
        animation.duration = 0.14
        animation.autoreverses = true
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.2, 0.4, 1)
        add(animation, forKey: nil)
        self.completion = completion
    }
}

extension BaseNetworkLayer: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        fillColor = UIColor.white.withAlphaComponent(0.0).cgColor
        let fadeAnimation = CABasicAnimation(keyPath: "fadePath")
        fadeAnimation.beginTime = 0
        fadeAnimation.fromValue = fillColor
        fadeAnimation.toValue = UIColor.white.withAlphaComponent(0.0).cgColor
        fadeAnimation.duration = 0.14
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        add(fadeAnimation, forKey: nil)
        self.completion?()
    }
}
