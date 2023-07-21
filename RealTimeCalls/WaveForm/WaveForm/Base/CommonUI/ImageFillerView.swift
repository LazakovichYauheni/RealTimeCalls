import UIKit
import SnapKit

public protocol ImageFillerViewStyle {
    static var imageSize: CGSize { get }
    static var imageInsets: CGFloat { get }
    static var radius: CGFloat { get }
    static var backgroundColor: UIColor { get }
}

public struct DefaultFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 20, height: 20) }
    public static var imageInsets: CGFloat { 10 }
    public static var radius: CGFloat { 20 }
    public static var backgroundColor: UIColor { .white.withAlphaComponent(0.2) }
}

public struct MediumFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 32, height: 32) }
    public static var imageInsets: CGFloat { 10 }
    public static var radius: CGFloat { 26 }
    public static var backgroundColor: UIColor { .white.withAlphaComponent(0.2) }
}

public struct LargeFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 24, height: 24) }
    public static var imageInsets: CGFloat { 14 }
    public static var radius: CGFloat { 26 }
    public static var backgroundColor: UIColor { .white.withAlphaComponent(0.2) }
}

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
