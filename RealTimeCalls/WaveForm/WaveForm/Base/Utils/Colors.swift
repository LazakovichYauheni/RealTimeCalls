//
//  Colors.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 24.03.23.
//

import Foundation
import UIKit

public enum Colors {
    public static let firstBlobColors: [UIColor] = [
        UIColor(red: 81 / 255, green: 163 / 255, blue: 207 / 255, alpha: 1),
        UIColor(red: 173 / 255, green: 189 / 255, blue: 101 / 255, alpha: 1)
    ]
    
    public static let secondBlobsColors: [UIColor] = [
        UIColor(red: 192 / 255, green: 79 / 255, blue: 141 / 255, alpha: 1),
        UIColor(red: 207 / 255, green: 81 / 255, blue: 128 / 255, alpha: 1)
    ]
    
    public static let thirdBlobsColors: [UIColor] = [
        UIColor(red: 165 / 255, green: 103 / 255, blue: 213 / 255, alpha: 1),
        UIColor(red: 86 / 255, green: 145 / 255, blue: 214 / 255, alpha: 1)
    ]
    
    public static let firstBackgroundColor = UIColor(red: 87 / 255, green: 158 / 255, blue: 135 / 255, alpha: 1)
    public static let secondBackgroundColor = UIColor(red: 229 / 255, green: 129 / 255, blue: 105 / 255, alpha: 1)
    public static let thirdBackgroundColor = UIColor(red: 116 / 255, green: 110 / 255, blue: 215 / 255, alpha: 1)
    
    public static let whiteColorWithAlpha01 = UIColor.white.withAlphaComponent(0.16)
    public static let whiteColorWithAlpha028 = UIColor.white.withAlphaComponent(0.28)
    public static let whiteColorWithAlpha020 = UIColor.white.withAlphaComponent(0.2)
}
