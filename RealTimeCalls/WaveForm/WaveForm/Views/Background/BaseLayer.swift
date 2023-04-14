//
//  BaseLayer.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 10.03.23.
//

import Foundation
import UIKit

public final class BaseLayer: CALayer {
    init(color: UIColor) {
        super.init()
        
        backgroundColor = color.cgColor
    }
    
    func set(color: UIColor) {
        backgroundColor = color.cgColor
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
