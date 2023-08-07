//
//  DotLayer.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 14.03.23.
//

import UIKit

public final class DotLayer: CAShapeLayer {
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public init(radius: CGFloat) {
        super.init()
        
        bounds = CGRect(origin: .zero, size: CGSize(width: radius * 2, height: radius * 2))
        path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        fillColor = Color.current.background.whiteColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
