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
    let secondLayer = BottomButtonLayer(color: UIColor.white)
    
    let maskLayer = CAShapeLayer()
    
    let backgroundLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.buttonClose
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.buttonClose
        label.textColor = UIColor(red: 170 / 255, green: 126 / 255, blue: 225 / 255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 16
        backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        secondLayer.addSublayer(secondLabel.layer)
        
        maskLayer.fillColor = UIColor.white.cgColor
        
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
            cornerRadius: 4
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
