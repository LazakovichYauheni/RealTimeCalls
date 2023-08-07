//
//  FilterView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

public protocol ButtonStyle {
    static var cornerRadius: CGFloat { get }
    static var activeColor: UIColor { get }
    static var disabledColor: UIColor { get }
    static var tappedColor: UIColor { get }
    
    static var textActiveColor: UIColor { get }
    static var textDisabledColor: UIColor { get }
}

struct DefaultButtonStyle: ButtonStyle {
    static var cornerRadius: CGFloat { 8 }
    static var activeColor: UIColor { Color.current.background.blueColor }
    static var disabledColor: UIColor { Color.current.background.disableGrayColor }
    static var tappedColor: UIColor { Color.current.background.darkBlueColor }
    
    static var textActiveColor: UIColor { Color.current.text.whiteColor }
    static var textDisabledColor: UIColor { Color.current.text.disableSecondaryColor }
}

struct DefaultRadius30ButtonStyle: ButtonStyle {
    static var cornerRadius: CGFloat { 30 }
    static var activeColor: UIColor { Color.current.background.blueColor }
    static var disabledColor: UIColor { Color.current.background.disableGrayColor }
    static var tappedColor: UIColor { Color.current.background.darkBlueColor }
    
    static var textActiveColor: UIColor { Color.current.text.whiteColor }
    static var textDisabledColor: UIColor { Color.current.text.disableSecondaryColor }
}

struct SecondaryButtonStyle: ButtonStyle {
    static var cornerRadius: CGFloat { 8 }
    static var activeColor: UIColor { Color.current.background.lightGrayColor }
    static var disabledColor: UIColor { Color.current.background.disableGrayColor }
    static var tappedColor: UIColor { Color.current.background.darkGrayColor }
    
    static var textActiveColor: UIColor { Color.current.text.blackColor }
    static var textDisabledColor: UIColor { Color.current.text.disableSecondaryColor }
}

struct WhiteButtonStyle: ButtonStyle {
    static var cornerRadius: CGFloat { 8 }
    static var activeColor: UIColor { Color.current.background.white.alpha30 }
    static var disabledColor: UIColor { Color.current.background.disableGrayColor }
    static var tappedColor: UIColor { Color.current.background.white.alpha60 }
    
    static var textActiveColor: UIColor { Color.current.text.whiteColor }
    static var textDisabledColor: UIColor { Color.current.text.disableSecondaryColor }
}

public final class PrimaryButton<Style: ButtonStyle>: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = Fonts.Medium.medium15
        setBackgroundImage(UIImage.make(with: Style.activeColor, cornerRadius: Style.cornerRadius), for: .normal)
        setBackgroundImage(UIImage.make(with: Style.tappedColor, cornerRadius: Style.cornerRadius), for: .highlighted)
        setBackgroundImage(UIImage.make(with: Style.disabledColor, cornerRadius: Style.cornerRadius), for: .disabled)
        
        setTitleColor(Style.textActiveColor, for: .normal)
        setTitleColor(Style.textActiveColor, for: .highlighted)
        setTitleColor(Style.textDisabledColor, for: .disabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimating() {
        setTitle(.empty, for: .normal)
        setImage(Images.loaderImage, for: .normal)
        self.imageView?.rotate()
    }
    
    public func stopAnimating() {
        self.imageView?.stopRotating()
        setImage(UIImage(), for: .normal)
    }
    
    public func setBackgroundColor(color: UIColor) {
        setBackgroundImage(UIImage.make(with: color, cornerRadius: Style.cornerRadius), for: .normal)
        setBackgroundImage(UIImage.make(with: color, cornerRadius: Style.cornerRadius), for: .highlighted)
        setBackgroundImage(UIImage.make(with: color, cornerRadius: Style.cornerRadius), for: .disabled)
    }
}
