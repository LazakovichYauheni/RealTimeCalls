//
//  ToastView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 16.03.23.
//

import UIKit
import SnapKit

private extension Spacer {
    var space15: CGFloat { 15 }
}

public final class ToastView: UIView {
    private lazy var label: UILabel = {
       let label = UILabel()
        label.textColor = Color.current.text.whiteColor
        label.textAlignment = .center
        label.font = Fonts.Regular.regular15
        label.text = "Weak network signal"
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(label)
        backgroundColor = Color.current.background.white.alpha20
        layer.cornerRadius = spacer.space15
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(spacer.space6)
            make.leading.trailing.equalToSuperview().inset(spacer.space12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
