//
//  UIView+Extensions.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 14.03.23.
//

import UIKit

extension UIView {
    func blur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = 0.5

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
