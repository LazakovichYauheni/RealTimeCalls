//
//  UserDetailsTableViewCell.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 18.07.23.
//

import UIKit

private extension Spacer {
    var space22: CGFloat { 22 }
}

final class ContactTableViewCell: UITableViewCell {
    
    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = spacer.space16
        view.backgroundColor = .white
        return view
    }()
    
    private(set) lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = spacer.space20
        return imageView
    }()
    
    private lazy var textContainer = UIView()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium16
        label.textColor = UIColor(red: 46 / 255, green: 46 / 255, blue: 46 / 255, alpha: 1)
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular12
        label.textColor = UIColor(red: 136 / 255, green: 153 / 255, blue: 168 / 255, alpha: 1)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(textContainer)
        textContainer.addSubview(titleLabel)
        textContainer.addSubview(descriptionLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(spacer.space8)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(spacer.space22)
            make.leading.equalToSuperview().inset(spacer.space16)
            make.size.equalTo(spacer.space40)
        }
        
        textContainer.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(spacer.space20)
            make.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space4)
        }
    }
}

extension ContactTableViewCell {
    struct ViewModel {
        let image: UIImage
        let title: String
        let description: String
    }
    
    func configure(viewModel: ViewModel) {
        iconImageView.image = viewModel.image
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}
