//
//  LiquidLayer.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.03.23.
//

import UIKit

public protocol LiquidLayerEventsRespondable: AnyObject {
    func buildingCompleted()
}

public final class LiquidLayer: CAShapeLayer {
    override public init(layer: Any) {
        super.init(layer: layer)
    }
    
    weak var layerDelegate: LiquidLayerEventsRespondable?
    override public init() {
        super.init()
        
        fillColor = Colors.whiteColorWithAlpha01.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func randomFloat(value: CGFloat) -> CGFloat {
        var random = arc4random() % 10000001
        random = (random * UInt32(value)) / 10000000
        return CGFloat(random)
    }
    
    private func randomFloatPlusOrMinus(value: CGFloat) -> CGFloat {
        let random = randomFloat(value: value * 2) - value
        return random
    }
    
    func buildPath(pointsCount: Int) {
        var path = UIBezierPath()
        let shortestSide = min(self.bounds.size.width, self.bounds.size.height)
        
        var angle: CGFloat = .zero
        let radiusBase: CGFloat = CGFloat(roundf(Float(shortestSide) * 3 / 9))
        var radius: CGFloat = .zero
        
        var x: CGFloat = .zero
        var y: CGFloat = .zero
        var aPoint: CGPoint = .init()
        
        for step in 0..<pointsCount {
            var randomValue: CGFloat = .zero
            
            angle = CGFloat.pi * CGFloat(2) / CGFloat(pointsCount) * CGFloat(step) + CGFloat.pi / 4 * 5
            
            randomValue = randomFloatPlusOrMinus(value: CGFloat.pi / CGFloat(pointsCount) * 0.9)
            angle += randomValue
            
            radius = radiusBase
            randomValue = randomFloatPlusOrMinus(value: radiusBase / 10)
            radius += randomValue
            
            x = round(cos(angle) * radius + shortestSide / 2)
            y = round(sin(angle) * radius + shortestSide / 2)
            aPoint = CGPoint(x: x, y: y)
            
            if step == .zero {
                path.move(to: aPoint)
            } else {
                path.addLine(to: aPoint)
            }
        }
        
        path.close()
        path = path.smoothedPath(granularity: 16)

        animatePath(path: path, pointsCount: pointsCount)
    }
    
    private func animatePath(path: UIBezierPath, pointsCount: Int) {
        let oldPath = self.path
        self.path = path.cgPath

        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = oldPath
        animation.toValue = path.cgPath
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        animation.delegate = self
        add(animation, forKey: nil)
    }
}

extension LiquidLayer: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            layerDelegate?.buildingCompleted()
        }
    }
}
