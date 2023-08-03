//
//  StarView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 15.04.23.
//

import UIKit
import SnapKit

final class StarView: UIView {
    public var id: Int = .zero

    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.starImage
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(starImageView)
    }
    
    private func makeConstraints() {
        starImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func configure(id: Int) {
        self.id = id
    }
    
    public func reconfigure(image: UIImage?) {
        starImageView.image = image
    }
    
    public func animate() {
        UIView.animate(
            withDuration: 0.15,
            delay: .zero,
            options: .curveLinear,
            animations: {
                self.starImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
            completion: { _ in
                self.starImageView.transform = .identity
            })
    }
}
