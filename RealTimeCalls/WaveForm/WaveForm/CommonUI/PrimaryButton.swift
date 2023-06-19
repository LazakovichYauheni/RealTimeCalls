//
//  FilterView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

public protocol ButtonStyle {
    static var activeColor: UIColor { get }
    static var disabledColor: UIColor { get }
    static var tappedColor: UIColor { get }
    
    static var textActiveColor: UIColor { get }
    static var textDisabledColor: UIColor { get }
}

struct DefaultButtonStyle: ButtonStyle {
    static var activeColor: UIColor { UIColor(red: 44 / 255, green: 102 / 255, blue: 189 / 255, alpha: 1) }
    static var disabledColor: UIColor { UIColor(red: 208 / 255, green: 220 / 255, blue: 228 / 255, alpha: 1) }
    static var tappedColor: UIColor { UIColor(red: 26 / 255, green: 66 / 255, blue: 124 / 255, alpha: 1) }
    
    static var textActiveColor: UIColor { .white }
    static var textDisabledColor: UIColor { UIColor(red: 12 / 255, green: 38 / 255, blue: 61 / 255, alpha: 0.24) }
}

struct SecondaryButtonStyle: ButtonStyle {
    static var activeColor: UIColor { UIColor(red: 216 / 255, green: 226 / 255, blue: 235 / 255, alpha: 1) }
    static var disabledColor: UIColor { UIColor(red: 208 / 255, green: 220 / 255, blue: 228 / 255, alpha: 1) }
    static var tappedColor: UIColor { UIColor(red: 204 / 255, green: 213 / 255, blue: 221 / 255, alpha: 1) }
    
    static var textActiveColor: UIColor { .black }
    static var textDisabledColor: UIColor { UIColor(red: 12 / 255, green: 38 / 255, blue: 61 / 255, alpha: 0.24) }
}

public final class PrimaryButton<Style: ButtonStyle>: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont(name: "GraphikLCG-Medium", size: 15)
        setBackgroundImage(UIImage.make(with: Style.activeColor, cornerRadius: 8), for: .normal)
        setBackgroundImage(UIImage.make(with: Style.tappedColor, cornerRadius: 8), for: .highlighted)
        setBackgroundImage(UIImage.make(with: Style.disabledColor, cornerRadius: 8), for: .disabled)
        
        setTitleColor(Style.textActiveColor, for: .normal)
        setTitleColor(Style.textActiveColor, for: .highlighted)
        setTitleColor(Style.textDisabledColor, for: .disabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
