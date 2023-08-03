import UIKit
import SnapKit

/// View для заполнения иконок с фоном
public final class AddUserView: UIView {
    // MARK: - Subview Properties

    // MARK: - Private Properties
    
    private lazy var iconImageView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular16
        label.text = "To add a new contact, just write \nit’s username in a field below"
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textField: FloatingTextFieldView = {
        let field = FloatingTextFieldView()
        field.clipsToBounds = true
        field.layer.cornerRadius = 12
        field.backgroundColor = .white
        return field
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
        backgroundColor = .clear
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(textField)
    }

    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(54)
            make.height.equalTo(56)
        }
    }
}

// MARK: - Configurable

extension AddUserView {
    public struct ViewModel {
        let image: UIImage
        let textFieldViewModel: FloatingTextFieldView.ViewModel
    }

    public func configure(with viewModel: ViewModel) {
        iconImageView.image = viewModel.image
        textField.configure(with: viewModel.textFieldViewModel)
    }
}
