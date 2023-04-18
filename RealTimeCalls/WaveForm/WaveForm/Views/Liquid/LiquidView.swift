//
//  LiquidView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.03.23.
//

import UIKit

public final class LiquidView: UIView {
    private let liquidLayer = LiquidLayer()
    
    private var flag = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        liquidLayer.layerDelegate = self
        layer.addSublayer(liquidLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        liquidLayer.frame = bounds
        if flag == false {
            change()
            flag = true
        }
    }
    
    func change() {
        liquidLayer.buildPath(pointsCount: 7)
    }
}

extension LiquidView: LiquidLayerEventsRespondable {
    public func buildingCompleted() {
        change()
    }
}
