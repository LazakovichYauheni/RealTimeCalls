//
//  TestButton.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 9.06.23.
//

import Foundation
import UIKit

public final class TestButton: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundImage(UIImage.make(with: UIColor(red: 44 / 255, green: 102 / 255, blue: 189 / 255, alpha: 1), cornerRadius: 8), for: .normal)
        setBackgroundImage(UIImage.make(with: UIColor(red: 208 / 255, green: 220 / 255, blue: 228 / 255, alpha: 1), cornerRadius: 8), for: .disabled)
        setBackgroundImage(UIImage.make(with: UIColor(red: 26 / 255, green: 66 / 255, blue: 124 / 255, alpha: 1), cornerRadius: 8), for: .focused)
        
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.white, for: .focused)
        setTitleColor(UIColor(red: 12 / 255, green: 38 / 255, blue: 61 / 255, alpha: 0.24), for: .disabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
