//
//  ToastView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 16.03.23.
//

import UIKit
import SnapKit

public final class ToastView: UIView {
    private lazy var label: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = label.font.withSize(FontSize.size15)
        label.text = "Weak network signal"
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(label)
        backgroundColor = Colors.whiteColorWithAlpha020
        layer.cornerRadius = 15
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
