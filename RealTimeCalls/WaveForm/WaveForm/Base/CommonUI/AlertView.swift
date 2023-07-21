//
//  AlertView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 21.07.23.
//

import UIKit

public struct AlertButtonModel {
    let background: UIColor
    let title: String
}

public protocol AlertViewStyle {
    static var titleColor: UIColor { get }
    static var descriptionColor: UIColor { get }
    static var backgroundColor: UIColor { get }
}

public final class AlertView<FillerStyle: ImageFillerViewStyle, AlertStyle: AlertViewStyle>: UIView {
    private lazy var iconImageView = ImageFillerView<FillerStyle>()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium15
        label.textColor = AlertStyle.titleColor
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular13
        label.textColor = AlertStyle.descriptionColor
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var buttonsContainerView = UIView()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = AlertStyle.backgroundColor
        layer.cornerRadius = 16
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(buttonsContainerView)
        buttonsContainerView.addSubview(buttonsStackView)
    }
    
    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.top)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        
        buttonsContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    private func setupStack(actions: [AlertButtonModel]) {
        actions.forEach { actionModel in
            let containerView: UIView = {
                let view = UIView()
                view.clipsToBounds = true
                view.layer.cornerRadius = 8
                view.backgroundColor = actionModel.background
                return view
            }()
            
            let titleView: UILabel = {
                let title = UILabel()
                title.text = actionModel.title
                title.font = Fonts.Medium.medium15
                title.textAlignment = .center
                return title
            }()
            
            containerView.addSubview(titleView)
            titleView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(8)
                make.leading.trailing.equalToSuperview().inset(16)
            }
            
            buttonsStackView.addArrangedSubview(containerView)
        }
    }
}

extension AlertView {
    struct ViewModel {
        let icon: UIImage
        let title: String
        let description: String
        let actions: [AlertButtonModel]
    }
    
    func configure(with viewModel: ViewModel) {
        iconImageView.configure(with: ImageFillerView<FillerStyle>.ViewModel(image: viewModel.icon))
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        setupStack(actions: viewModel.actions)
    }
}
