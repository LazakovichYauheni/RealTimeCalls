//
//  CubeLabel.swift
//  CubeTransitionLabel
//
//  Created by Jian Zhang on 3/9/17.
//  Copyright © 2017 AZ. All rights reserved.
//

import UIKit

enum TransitionDirection: Int {
    case up = 1
    case down = -1
}

class CubeLabel: UILabel {
    func cubeTransition(newText: String, direction: TransitionDirection, duration: CGFloat) {
        self.superview?.clipsToBounds = true
        let auxLabel = UILabel(frame: self.frame)
        auxLabel.text = newText
        auxLabel.backgroundColor = self.backgroundColor
        auxLabel.font = self.font
        auxLabel.textColor = self.textColor
        auxLabel.textAlignment = self.textAlignment
        self.superview?.addSubview(auxLabel)
        
        let auxLabelOffset = auxLabel.frame.height / 2 * CGFloat(direction.rawValue)
        auxLabel.transform = (CGAffineTransform(scaleX: 0.4, y: 0.1)).concatenating(
            CGAffineTransform(translationX: 0, y: auxLabelOffset)
        )
        
        UIView.animate(
            withDuration: TimeInterval(duration),
            delay: 0,
            options: .curveEaseOut,
            animations: {
                auxLabel.transform = CGAffineTransform.identity
                auxLabel.alpha = 1
                self.alpha = 0
                self.transform = (CGAffineTransform(scaleX: 0.4, y: 0.1)).concatenating(
                    CGAffineTransform.init(translationX: 0, y: -auxLabelOffset)
                )
            }) { _ in
                self.text = newText
                self.alpha = 1
                self.transform = CGAffineTransform.identity
                
                auxLabel.removeFromSuperview()
            }
    }
}
