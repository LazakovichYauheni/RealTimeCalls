import UIKit

private enum Constants {
    static let layerAlpha: CGFloat = 0.04
    static let layerShadowRadius: CGFloat = 16
    static let layerShadowOpacity: Float = 1
    static let layerShadowOffset: CGSize = CGSize(width: .zero, height: 6) 
}

private extension Spacer {
    var space22: CGFloat { 22 }
    var space45: CGFloat { 45 }
    var iconSize: CGSize { CGSize(width: 90, height: 90) }
}

/// Ячейка для карточки партнера с возможностью активации
public final class MainScreenCollectionViewCell: UICollectionViewCell {
    public lazy var randomHue = CGFloat.random(in: (0...1))
    
    public lazy var background = UIColor(hue: randomHue, saturation: 0.44, brightness: 0.76, alpha: 1)
    
    // MARK: - Subview Properties

    private(set) lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = spacer.space45
        return image
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium20
        label.textColor = Color.current.text.whiteColor
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular24
        label.textColor = Color.current.text.whiteColor
        return label
    }()
    
    private lazy var subDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular14
        label.textColor = Color.current.text.whiteColor
        return label
    }()
    
    private(set) lazy var callIconView = ImageFillerView<DefaultFillerViewStyle>(frame: .zero)

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeAppearance(isSelected: Bool) {
        UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseInOut) {
            self.backgroundColor = isSelected
                ? self.background.withAlphaComponent(0.15)
                : self.background.withAlphaComponent(1)
            self.callIconView.changeBackgroundAnimated(with: isSelected ? self.background : nil)
        }
        titleLabel.textColor = isSelected ? Color.current.text.blackColor : Color.current.text.whiteColor
        descriptionLabel.textColor = isSelected ? Color.current.text.blackColor : Color.current.text.whiteColor
        subDescriptionLabel.textColor = isSelected ? Color.current.text.blackColor : Color.current.text.whiteColor
        
        if isSelected {
            addAnim()
        } else {
            let shapeLayers = layer.sublayers?.filter { $0 is CAShapeLayer }
            shapeLayers?.forEach {
                $0.removeFromSuperlayer()
                $0.removeAllAnimations()
            }
        }
    }
    
    private func addAnim() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.24
        animation.fromValue = 0
        animation.toValue = 1
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction.init(name: .linear)
        animation.isRemovedOnCompletion = false
        
        let topLeftPath = UIBezierPath(
            arcCenter: CGPoint(
                x: bounds.maxX - 16,
                y: bounds.minY + 16
            ),
            radius: 16,
            startAngle: -(.pi / 4),
            endAngle: (3 * .pi) / 2,
            clockwise: false
        )
        topLeftPath.addLine(
            to: CGPoint(
                x: bounds.minX + 16,
                y: bounds.minY
            )
        )
        topLeftPath.addArc(
            withCenter: CGPoint(
                x: bounds.minX + 16,
                y: bounds.minY + 16
            ),
            radius: 16,
            startAngle: (3 * .pi) / 2,
            endAngle: (5 * .pi) / 4,
            clockwise: false
        )
        
        let bottomLeft = UIBezierPath(
            arcCenter: CGPoint(
                x: bounds.minX + 16,
                y: bounds.maxY - 16
            ),
            radius: 16,
            startAngle: (3 * .pi) / 4,
            endAngle: .pi,
            clockwise: true
        )
        bottomLeft.addLine(
            to: CGPoint(
                x: bounds.minX,
                y: bounds.minY + 16
            )
        )
        bottomLeft.addArc(
            withCenter: CGPoint(
                x: bounds.minX + 16,
                y: bounds.minY + 16
            ),
            radius: 16,
            startAngle: .pi,
            endAngle: 5 * .pi / 4,
            clockwise: true
        )
        
        let bottomRight = UIBezierPath(
            arcCenter: CGPoint(
                x: bounds.minX + 16,
                y: bounds.maxY - 16
            ),
            radius: 16,
            startAngle: 3 * .pi / 4,
            endAngle: .pi / 2,
            clockwise: false
        )
        
        bottomRight.addLine(
            to: CGPoint(
                x: bounds.maxX - 16,
                y: bounds.maxY
            )
        )
        
        bottomRight.addArc(
            withCenter: CGPoint(
                x: bounds.maxX - 16,
                y: bounds.maxY - 16
            ),
            radius: 16,
            startAngle: .pi / 2,
            endAngle: .pi / 4,
            clockwise: false
        )
        
        let topRight = UIBezierPath(
            arcCenter: CGPoint(
                x: bounds.maxX - 16,
                y: bounds.minY + 16
            ),
            radius: 16,
            startAngle: (7 * .pi) / 4,
            endAngle: .zero,
            clockwise: true
        )
        
        topRight.addLine(
            to: CGPoint(
                x: bounds.maxX,
                y: bounds.maxY - 16
            )
        )
        
        topRight.addArc(
            withCenter: CGPoint(
                x: bounds.maxX - 16,
                y: bounds.maxY - 16
            ),
            radius: 16,
            startAngle: .zero,
            endAngle: .pi / 4,
            clockwise: true
        )

        addLayer(animation: animation, path: topLeftPath)
        addLayer(animation: animation, path: bottomLeft)
        addLayer(animation: animation, path: bottomRight)
        addLayer(animation: animation, path: topRight)
    }
    
    private func addLayer(animation: CABasicAnimation, path: UIBezierPath) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 6
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = background.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.add(animation, forKey: "strokeEnd")
        layer.addSublayer(shapeLayer)
    }

    // MARK: - Private Methods

    private func initialize() {
        clipsToBounds = true
        layer.cornerRadius = spacer.space16
        layer.borderColor = Color.current.background.whiteColor.cgColor
        backgroundColor = background
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(subDescriptionLabel)
        contentView.addSubview(callIconView)
    }

    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(spacer.space16)
            make.size.equalTo(spacer.iconSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(spacer.space48)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space8)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        subDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(spacer.space20)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.bottom.lessThanOrEqualTo(callIconView.snp.top).inset(spacer.space16)
        }
        
        callIconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(spacer.space22)
        }
    }
}

// MARK: - Configurable

extension MainScreenCollectionViewCell {
    public struct ViewModel {
        let name: String
        let lastName: String
        let infoMessage: String
        let image: UIImage
        let callImage: UIImage
        let isNeedToShowBorder: Bool
        let backgroundColor: UIColor
        let buttonBackground: UIColor
    }
    
    func configure(with viewModel: ViewModel) {
        backgroundColor = viewModel.backgroundColor
        background = viewModel.backgroundColor
        iconImageView.image = viewModel.image
        titleLabel.text = viewModel.name
        descriptionLabel.text = viewModel.lastName
        subDescriptionLabel.text = viewModel.infoMessage
        callIconView.configure(with: .init(image: viewModel.callImage))
        changeAppearance(isSelected: false)
    }
}
