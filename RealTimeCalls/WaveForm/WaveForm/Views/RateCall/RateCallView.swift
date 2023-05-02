//
//  RateCallView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 15.04.23.
//

import UIKit
import SnapKit

final class RateCallView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: FontSize.size15)
        label.textAlignment = .center
        label.text = "Rate This Call"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(FontSize.size15)
        label.textAlignment = .center
        label.text = "Please rate the quality of this call"
        return label
    }()
    
    private lazy var starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 12
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white.withAlphaComponent(0.25)
        clipsToBounds = true
        layer.cornerRadius = 20
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        let iconWidth = (UIScreen.main.bounds.width - 188) / 5
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(starsStackView)
        (0...4).forEach { index in
            let imageView = StarView()
            imageView.configure(id: index)
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
            imageView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: iconWidth, height: iconWidth))
            }
            starsStackView.addArrangedSubview(imageView)
        }
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(14)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(14)
        }
        
        starsStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc private func viewTapped(_ sender: UIGestureRecognizer) {
        guard let image = sender.view as? StarView else { return }
        print(image.id)
        starsStackView.subviews.forEach { imageView in
            guard let imageView = imageView as? StarView else { return }
            imageView.reconfigure(image: UIImage(named: "star"))
        }
        
        starsStackView.subviews.prefix(image.id + 1).forEach { imageView in
            guard let imageView = imageView as? StarView else { return }
            imageView.reconfigure(image: UIImage(named: "maskStar"))
            imageView.animate()
        }
    }
}
