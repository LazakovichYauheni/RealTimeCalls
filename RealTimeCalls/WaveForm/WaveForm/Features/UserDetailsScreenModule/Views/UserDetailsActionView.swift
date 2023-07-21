import UIKit
import SnapKit

/// View для заполнения иконок с фоном
public final class UserDetailsActionView: UIView {
    // MARK: - Subview Properties

    private lazy var iconImageView = ImageFillerView<LargeFillerViewStyle>()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular16
        label.textColor = .white
        label.textAlignment = .center
        return label
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

    // MARK: - Private Methods

    private func commonInit() {
        addSubviews()
        makeConstraints()
        backgroundColor = .clear
    }

    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }

    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(titleLabel)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(14)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - Configurable

extension UserDetailsActionView {
    public struct ViewModel {
        let image: UIImage
        let buttonTitle: String
        let imageBackgroundColor: UIColor
    }

    public func configure(with viewModel: ViewModel) {
        iconImageView.configure(with: ImageFillerView<LargeFillerViewStyle>.ViewModel(image: viewModel.image))
        titleLabel.text = viewModel.buttonTitle
        iconImageView.changeBackground(with: viewModel.imageBackgroundColor)
    }
}
