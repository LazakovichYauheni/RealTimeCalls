import UIKit
import SnapKit

/// View для заполнения иконок с фоном
public final class MainScreenContactView: UIView {
    // MARK: - Subview Properties

    private lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = spacer.space30
        return image
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium16
        label.textColor = Color.current.text.darkGrayColor
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
        backgroundColor = Color.current.background.whiteColor
        layer.cornerRadius = spacer.space16
    }

    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }

    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(spacer.space40)
            make.leading.equalToSuperview().inset(spacer.space16)
            make.size.equalTo(spacer.space40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(spacer.space20)
            make.trailing.equalToSuperview().inset(spacer.space16)
            make.centerY.equalTo(iconImageView)
        }
    }
}

// MARK: - Configurable

extension MainScreenContactView {
    public struct ViewModel {
        let name: String
    }

    public func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.name
    }
}
