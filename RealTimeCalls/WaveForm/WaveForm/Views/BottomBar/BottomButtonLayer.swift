//
//  BottomButtonLayer.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 16.03.23.
//

import UIKit

public final class BottomButtonLayer: CAShapeLayer {
    private var oldPath: UIBezierPath = .init()
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public init(color: UIColor) {
        super.init()
        fillColor = color.cgColor
        cornerRadius = 30
    }
    
    override public func layoutSublayers() {
        super.layoutSublayers()
        let updatedPath = UIBezierPath(rect: CGRect(x: .zero, y: .zero, width: self.bounds.width, height: self.bounds.height))
        path = updatedPath.cgPath
    }
    
    func animate() {
        CATransaction.begin()
        CATransaction.setValue(5, forKey: kCATransactionAnimationDuration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .linear))
        mask?.position.x = bounds.maxX + bounds.width / 2
        CATransaction.commit()
    }
    
    func setColor(color: UIColor) {
        fillColor = color.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
