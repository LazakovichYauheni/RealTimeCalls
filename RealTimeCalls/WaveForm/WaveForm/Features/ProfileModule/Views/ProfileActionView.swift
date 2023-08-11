//
//  ProfileActionView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 11.08.23.
//

import UIKit

protocol ProfileActionViewEventsRespondable {
    func viewTapped(id: Int)
}

final class ProfileActionView: UIView {
    private lazy var iconImageView = ImageFillerView<SmallGrayWithoutAlphaRadius12FillerViewStyle>()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium14
        label.textColor = Color.current.text.blackColor
        return label
    }()
    
    private var id: Int = .zero
    private lazy var responder = Weak(firstResponder(of: ProfileActionViewEventsRespondable.self))
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = .clear
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(spacer.space8)
            make.trailing.equalToSuperview()
        }
    }
    
    @objc private func viewTapped() {
        responder.object?.viewTapped(id: id)
    }
}

extension ProfileActionView {
    struct ViewModel {
        let id: Int
        let icon: UIImage
        let title: String
    }
    
    func configure(viewModel: ViewModel) {
        id = viewModel.id
        iconImageView.configure(with: .init(image: viewModel.icon))
        titleLabel.text = viewModel.title
    }
}
