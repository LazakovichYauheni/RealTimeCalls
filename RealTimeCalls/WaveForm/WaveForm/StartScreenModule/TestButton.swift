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
        setBackgroundImage(UIImage.make(with: Color.current.background.blueColor, cornerRadius: 8), for: .normal)
        setBackgroundImage(UIImage.make(with: Color.current.background.disableGrayColor, cornerRadius: 8), for: .disabled)
        setBackgroundImage(UIImage.make(with: Color.current.background.darkBlueColor, cornerRadius: 8), for: .focused)
        
        setTitleColor(Color.current.background.whiteColor, for: .normal)
        setTitleColor(Color.current.background.whiteColor, for: .focused)
        setTitleColor(Color.current.text.disableSecondaryColor, for: .disabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
