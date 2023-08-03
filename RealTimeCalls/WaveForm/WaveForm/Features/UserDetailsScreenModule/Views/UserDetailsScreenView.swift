import UIKit
import SnapKit

private extension Spacer {
    var headerViewHeight: CGFloat { 300 }
}

protocol UserDetailsScreenEventsRespondable: AnyObject {
    func didCloseButtonTapped()
    func didSelectCell(index: Int)
}

public final class UserDetailsScreenView: UIView {
    // MARK: - Subview Properties
    
    public lazy var headerView = UIView()

    public lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var textContainerView = UIView()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium24
        label.textColor = .white
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular20
        label.textColor = .white
        return label
    }()
    
    private(set) lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = spacer.space16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    private(set) lazy var closeButton: PrimaryButton<WhiteButtonStyle> = {
        let button = PrimaryButton<WhiteButtonStyle>()
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.setTitle("Close", for: .normal)
        return button
    }()
    
    private lazy var responder = Weak(firstResponder(of: UserDetailsScreenEventsRespondable.self))

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func commonInit() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(headerView)
        headerView.addSubview(iconImageView)
        headerView.addSubview(textContainerView)
        textContainerView.addSubview(titleLabel)
        textContainerView.addSubview(descriptionLabel)
        addSubview(contentView)
        contentView.addSubview(buttonsStackView)
        contentView.addSubview(closeButton)
    }

    private func makeConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(spacer.headerViewHeight)
        }
        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(spacer.space40)
            make.leading.equalToSuperview().inset(spacer.space24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space4)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).inset(spacer.space20)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(spacer.space32)
        }
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(spacer.space40)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.height.equalTo(spacer.space60)
        }
    }
    
    @objc private func closeButtonTapped() {
        responder.object?.didCloseButtonTapped()
    }
    
    private func setupButtonsStack(buttonViewModels: [UserDetailsActionView.ViewModel]) {
        buttonViewModels.forEach { viewModel in
            let view = UserDetailsActionView()
            view.configure(with: viewModel)
            buttonsStackView.addArrangedSubview(view)
        }
    }
}

// MARK: - Configurable

extension UserDetailsScreenView {
    public struct ViewModel {
        let iconImage: UIImage
        let name: String
        let lastName: String
        let backgroundColor: UIColor
        let actionButtonViewModels: [UserDetailsActionView.ViewModel]
    }

    public func configure(with viewModel: ViewModel) {
        setupButtonsStack(buttonViewModels: viewModel.actionButtonViewModels)
        iconImageView.image = viewModel.iconImage
        titleLabel.text = viewModel.name
        descriptionLabel.text = viewModel.lastName
        contentView.backgroundColor = viewModel.backgroundColor
    }
}
