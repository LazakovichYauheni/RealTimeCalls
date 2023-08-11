import UIKit

public protocol ProfileViewEventsRespondable {
    func iconTapped()
}

public final class ProfileView: UIView {
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iconTapped)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium18
        label.textAlignment = .center
        label.textColor = Color.current.text.blackColor
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular16
        label.textAlignment = .center
        label.textColor = Color.current.text.secondaryColor
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = spacer.space24
        view.backgroundColor = Color.current.background.whiteColor
        return view
    }()
    
    private lazy var stackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = spacer.space16
        return stack
    }()
    
    private lazy var responder = Weak(firstResponder(of: ProfileViewEventsRespondable.self))
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = Color.current.background.mainColor
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(usernameLabel)
        addSubview(containerView)
        containerView.addSubview(stackView)
    }
    
    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(spacer.space40)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(spacer.space24)
            make.leading.trailing.equalToSuperview()
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space4)
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(spacer.space42)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.top.greaterThanOrEqualTo(usernameLabel.snp.bottom).offset(spacer.space16)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(spacer.space24)
        }
    }
    
    @objc private func iconTapped() {
        responder.object?.iconTapped()
    }
    
    private func setupStack(viewModels: [ProfileActionView.ViewModel]) {
        viewModels.forEach { viewModel in
            let view = ProfileActionView()
            view.configure(viewModel: viewModel)
            stackView.addArrangedSubview(view)
        }
    }
}

extension ProfileView {
    struct ViewModel {
        let iconImage: UIImage
        let title: String
        let username: String
        let actionViewModels: [ProfileActionView.ViewModel]
    }

    func configure(viewModel: ProfileView.ViewModel) {
        iconImageView.image = viewModel.iconImage
        titleLabel.text = viewModel.title
        usernameLabel.text = viewModel.username
        setupStack(viewModels: viewModel.actionViewModels)
        layoutIfNeeded()
        addGradientBorder(to: iconImageView, lineWidth: 6)
    }
}
