import UIKit
import SnapKit

/// View для заполнения иконок с фоном
public final class MainScreenContactView: UIView {
    // MARK: - Subview Properties

    private lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        return image
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium16
        label.textColor = UIColor(red: 46 / 255, green: 46 / 255, blue: 46 / 255, alpha: 1)
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
        backgroundColor = .white
        layer.cornerRadius = 16
    }

    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }

    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(16)
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
