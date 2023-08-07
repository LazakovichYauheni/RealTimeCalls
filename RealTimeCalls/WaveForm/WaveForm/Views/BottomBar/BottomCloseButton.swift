//
//  BottomCloseButton.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 17.03.23.
//

import UIKit
import SnapKit

protocol BottomCloseButtonDelegate: AnyObject {
    func tapped()
}

public final class BottomCloseButton: UIView {
    weak var delegate: BottomCloseButtonDelegate?
    let secondLayer = BottomButtonLayer(color: Color.current.background.whiteColor)
    
    let maskLayer = CAShapeLayer()
    
    let backgroundLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.buttonClose
        label.textColor = Color.current.text.whiteColor
        label.textAlignment = .center
        return label
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.buttonClose
        label.textColor = Color.current.text.lightPurpleColor
        label.textAlignment = .center
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = spacer.space16
        backgroundColor = Color.current.background.white.alpha20
        
        addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        secondLayer.addSublayer(secondLabel.layer)
        
        maskLayer.fillColor = Color.current.background.whiteColor.cgColor
        
        layer.addSublayer(secondLayer)
        secondLayer.mask = maskLayer
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        secondLayer.frame = bounds
        secondLabel.layer.frame = bounds
        
        maskLayer.frame = bounds
        maskLayer.path = UIBezierPath(
            roundedRect: CGRect(x: .zero, y: .zero, width: bounds.width, height: bounds.height),
            cornerRadius: spacer.space4
        ).cgPath
    }
    
    func animate() {
        DispatchQueue.main.async {
            self.secondLayer.animate() {
                self.delegate?.tapped()
            }
        }
    }
    
    @objc private func tapped() {
        delegate?.tapped()
    }
}
