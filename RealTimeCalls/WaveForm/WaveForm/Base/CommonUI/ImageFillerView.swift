import UIKit
import SnapKit

protocol ImageFillerViewEventsRespondable {
    func imageTapped(id: Int)
}

/// View для заполнения иконок с фоном
public final class ImageFillerView<Style: ImageFillerViewStyle>: UIView {
    // MARK: - Subview Properties

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    public var id: Int = .zero
    private lazy var responder = Weak(firstResponder(of: ImageFillerViewEventsRespondable.self))

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
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
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
    
    @objc private func tapped() {
        responder.object?.imageTapped(id: id)
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
        var id: Int = 0
        let image: UIImage
    }

    public func configure(with viewModel: ViewModel) {
        id = viewModel.id
        iconImageView.image = viewModel.image
    }
}
