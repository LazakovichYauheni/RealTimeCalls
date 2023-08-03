import UIKit
import SnapKit

/// View для заполнения иконок с фоном
public final class ImageFillerView<Style: ImageFillerViewStyle>: UIView {
    // MARK: - Subview Properties

    private lazy var iconImageView = UIImageView()

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
        backgroundColor = Style.backgroundColor
        layer.cornerRadius = Style.radius
    }

    private func addSubviews() {
        addSubview(iconImageView)
    }

    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(Style.imageSize)
            make.edges.equalToSuperview().inset(Style.imageInsets)
        }
    }
    
    func changeBackground(with color: UIColor) {
        backgroundColor = color
    }
    
    func changeBackgroundAnimated(with color: UIColor?) {
        UIView.animate(withDuration: 0.2, delay: .zero) {
            self.backgroundColor = color == nil ? Style.backgroundColor : color
        }
    }
    
    func setIconVisibilityAnimated(isHidden: Bool) {
        UIView.animate(withDuration: 0.2, delay: .zero) {
            self.iconImageView.isHidden = isHidden
        }
    }
}

// MARK: - Configurable

extension ImageFillerView {
    public struct ViewModel {
        let image: UIImage
    }

    public func configure(with viewModel: ViewModel) {
        iconImageView.image = viewModel.image
    }
}
