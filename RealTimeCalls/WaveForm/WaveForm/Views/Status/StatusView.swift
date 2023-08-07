//
//  StatusView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 14.03.23.
//

import UIKit
import SnapKit

public final class StatusView: UIView, StatusProtocol {
    private lazy var titleLabel: CubeLabel = {
        let label = CubeLabel()
        label.textColor = Color.current.text.whiteColor
        label.font = Fonts.Regular.regular15
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dotsView = DotsView(frame: .zero)
    
    public init(text: String) {
        super.init(frame: .zero)
        
        addSubviews()
        makeConstraints()
        
        titleLabel.text = text
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(dotsView)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        dotsView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(spacer.space4)
            make.width.equalTo(spacer.space10)
        }
    }
}
