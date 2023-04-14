//
//  BaseNetworkView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 14.03.23.
//

import UIKit

public final class BaseNetworkView: UIView {
    private var baseLayer: BaseNetworkLayer?
    private var animatedLayer: BaseNetworkLayer?
    
    private var layerHeight: CGFloat = .zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(layerHeight: CGFloat) {
        super.init(frame: .zero)
        self.layerHeight = layerHeight
        let baseLayer = BaseNetworkLayer(color: Colors.whiteColorWithAlpha028, height: layerHeight)
        let animatedLayer = BaseNetworkLayer(color: UIColor.white, height: layerHeight)
        self.baseLayer = baseLayer
        self.animatedLayer = animatedLayer
        layer.addSublayer(baseLayer)
        layer.addSublayer(animatedLayer)
    }
    
    func tapped(completion: @escaping () -> Void) {
        animatedLayer?.animate(height: layerHeight + 1) {
            completion()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        baseLayer?.frame = bounds
        animatedLayer?.frame = bounds
    }
}
