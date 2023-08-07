import UIKit
import SnapKit

private extension Spacer {
    var space52: CGFloat { 52 }
}

protocol UserDetailsContentViewEventsRespondable: AnyObject {
    func didCloseButtonTapped()
}

/// View для заполнения иконок с фоном
public final class UserDetailsContentView: UIView {
    // MARK: - Subview Properties
    
    private lazy var textContainerView = UIView()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium36
        label.textColor = Color.current.text.whiteColor
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular28
        label.textColor = Color.current.text.whiteColor
        return label
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular20
        label.numberOfLines = .zero
        label.textColor = Color.current.text.noticeColor
        return label
    }()
    
    private lazy var closeButton: PrimaryButton<DefaultRadius30ButtonStyle> = {
        let button = PrimaryButton<DefaultRadius30ButtonStyle>()
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private Properties
    
    private lazy var responder = Weak(firstResponder(of: UserDetailsContentViewEventsRespondable.self))

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
        layer.cornerRadius = spacer.space18
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(textContainerView)
        textContainerView.addSubview(titleLabel)
        textContainerView.addSubview(descriptionLabel)
        textContainerView.addSubview(noticeLabel)
        addSubview(closeButton)
    }

    private func makeConstraints() {
        textContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(spacer.space30)
            make.leading.equalToSuperview().inset(spacer.space16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space4)
            make.leading.trailing.equalToSuperview()
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(spacer.space36)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(spacer.space52)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
    }
    
    @objc private func closeButtonTapped() {
        responder.object?.didCloseButtonTapped()
    }
}

// MARK: - Configurable

extension UserDetailsContentView {
    public struct ViewModel {
        let background: UIColor
        let buttonBackground: UIColor
        let title: String
        let description: String
        let notice: String?
    }

    public func configure(with viewModel: ViewModel) {
        backgroundColor = viewModel.background
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        noticeLabel.text = viewModel.notice
        closeButton.setBackgroundColor(color: viewModel.buttonBackground)
    }
}
