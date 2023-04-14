//
//  DotsView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 14.03.23.
//

import UIKit

public final class DotsView: UIView {
    private var dotLayers: [DotLayer] = []
    private let dotRadius: CGFloat = 1.5
    private let dotSpacing: CGFloat = 2
    private let dotsCount = 3
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        let center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        let middle: Int = dotsCount / 2
        for (index, layer) in dotLayers.enumerated() {
            let x = center.x + CGFloat(index - middle) * ((dotRadius * 2) + dotSpacing)
            layer.position = CGPoint(x: x, y: center.y)
        }
        startAnimating()
    }
    
    private func initialize() {
        (0..<dotsCount).forEach { _ in
            let dotLayer = DotLayer(radius: dotRadius)
            dotLayers.append(dotLayer)
            layer.addSublayer(dotLayer)
        }
    }
    
    private func scaleAnimation(timeOffset: TimeInterval = 0) -> CAAnimationGroup {
        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.beginTime = timeOffset
        scaleUp.fromValue = 1
        scaleUp.toValue = 1.4
        scaleUp.duration = 0.3
        scaleUp.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.beginTime = timeOffset + scaleUp.duration
        scaleDown.fromValue = 1.4
        scaleDown.toValue = 1.0
        scaleDown.duration = 0.2
        scaleDown.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        let group = CAAnimationGroup()
        group.animations = [scaleUp, scaleDown]
        group.repeatCount = Float.infinity

        let sum = CGFloat(dotsCount) * 0.2 + CGFloat(0.4)
        group.duration = CFTimeInterval(sum)

        return group
    }
    
    private func startAnimating() {
        var offset: TimeInterval = 0.0
        dotLayers.forEach {
            $0.removeAllAnimations()
            $0.add(scaleAnimation(timeOffset: offset), forKey: nil)
            offset = offset + 0.25
        }
    }
}
