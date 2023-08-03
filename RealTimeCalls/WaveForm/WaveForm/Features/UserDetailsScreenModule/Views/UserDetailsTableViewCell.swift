//
//  UserDetailsTableViewCell.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 18.07.23.
//

import UIKit

final class UserDetailsTableViewCell: UITableViewCell {
    private lazy var iconFillerView = ImageFillerView<MediumFillerViewStyle>()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular16
        label.textColor = .white
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
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(iconFillerView)
        contentView.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        iconFillerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(spacer.space16)
            make.leading.equalToSuperview().inset(spacer.space24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconFillerView.snp.trailing).offset(spacer.space28)
            make.trailing.equalToSuperview().inset(spacer.space16)
            make.centerY.equalTo(iconFillerView)
        }
    }
}

extension UserDetailsTableViewCell {
    struct ViewModel {
        let title: String
        let image: UIImage
    }
    
    func configure(viewModel: ViewModel) {
        iconFillerView.configure(with: ImageFillerView<MediumFillerViewStyle>.ViewModel(image: viewModel.image))
        titleLabel.text = viewModel.title
    }
}
