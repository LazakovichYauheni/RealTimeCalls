import UIKit
import CollectionViewPagingLayout

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

public final class MainScreenCollectionViewCell: UICollectionViewCell, StackTransformView {
    public var stackOptions = StackTransformViewOptions(
            scaleFactor: 0.06,
            minScale: 0.20,
            maxScale: 1.00,
            maxStackSize: 6,
            spacingFactor: 0.13,
            maxSpacing: nil,
            alphaFactor: 0.00,
            bottomStackAlphaSpeedFactor: 0.90,
            topStackAlphaSpeedFactor: 0.30,
            perspectiveRatio: 0.8,
            shadowEnabled: true,
            shadowColor: .black,
            shadowOpacity: 0.10,
            shadowOffset: .zero,
            shadowRadius: 5.00,
            stackRotateAngel: 0.00,
            popAngle: 0.26,
            popOffsetRatio: .init(width: -1.45, height: 0.30),
            stackPosition: .init(x: 1.00, y: 0.00),
            reverse: false,
            blurEffectEnabled: false,
            maxBlurEffectRadius: 0.00,
            blurEffectStyle: .light
        )
    
    // MARK: - Subview Properties
    
    private(set) lazy var containerView = UIView()

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
    
    // MARK: - Private
    
    private lazy var gradientColors: [UIColor] = []
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.cornerRadius = spacer.space24
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [gradientColors[0].cgColor, gradientColors[1].cgColor]
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func changeAppearance(isSelected: Bool) {
        if isSelected {
            addAnim()
        } else {
            let shapeLayers = containerView.layer.sublayers?.filter { $0 is CAShapeLayer }
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
                x: containerView.bounds.maxX - 16,
                y: containerView.bounds.minY + 16
            ),
            radius: 16,
            startAngle: -(.pi / 4),
            endAngle: (3 * .pi) / 2,
            clockwise: false
        )
        topLeftPath.addLine(
            to: CGPoint(
                x: containerView.bounds.minX + 16,
                y: containerView.bounds.minY
            )
        )
        topLeftPath.addArc(
            withCenter: CGPoint(
                x: containerView.bounds.minX + 16,
                y: containerView.bounds.minY + 16
            ),
            radius: 16,
            startAngle: (3 * .pi) / 2,
            endAngle: (5 * .pi) / 4,
            clockwise: false
        )
        
        let bottomLeft = UIBezierPath(
            arcCenter: CGPoint(
                x: containerView.bounds.minX + 16,
                y: containerView.bounds.maxY - 16
            ),
            radius: 16,
            startAngle: (3 * .pi) / 4,
            endAngle: .pi,
            clockwise: true
        )
        bottomLeft.addLine(
            to: CGPoint(
                x: containerView.bounds.minX,
                y: containerView.bounds.minY + 16
            )
        )
        bottomLeft.addArc(
            withCenter: CGPoint(
                x: containerView.bounds.minX + 16,
                y: containerView.bounds.minY + 16
            ),
            radius: 16,
            startAngle: .pi,
            endAngle: 5 * .pi / 4,
            clockwise: true
        )
        
        let bottomRight = UIBezierPath(
            arcCenter: CGPoint(
                x: containerView.bounds.minX + 16,
                y: containerView.bounds.maxY - 16
            ),
            radius: 16,
            startAngle: 3 * .pi / 4,
            endAngle: .pi / 2,
            clockwise: false
        )
        
        bottomRight.addLine(
            to: CGPoint(
                x: containerView.bounds.maxX - 16,
                y: containerView.bounds.maxY
            )
        )
        
        bottomRight.addArc(
            withCenter: CGPoint(
                x: containerView.bounds.maxX - 16,
                y: containerView.bounds.maxY - 16
            ),
            radius: 16,
            startAngle: .pi / 2,
            endAngle: .pi / 4,
            clockwise: false
        )
        
        let topRight = UIBezierPath(
            arcCenter: CGPoint(
                x: containerView.bounds.maxX - 16,
                y: containerView.bounds.minY + 16
            ),
            radius: 16,
            startAngle: (7 * .pi) / 4,
            endAngle: .zero,
            clockwise: true
        )
        
        topRight.addLine(
            to: CGPoint(
                x: containerView.bounds.maxX,
                y: containerView.bounds.maxY - 16
            )
        )
        
        topRight.addArc(
            withCenter: CGPoint(
                x: containerView.bounds.maxX - 16,
                y: containerView.bounds.maxY - 16
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
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.add(animation, forKey: "strokeEnd")
        containerView.layer.addSublayer(shapeLayer)
    }

    // MARK: - Private Methods

    private func initialize() {
        clipsToBounds = true
        containerView.layer.cornerRadius = spacer.space24
        containerView.layer.borderColor = Color.current.background.whiteColor.cgColor
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(callIconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(subDescriptionLabel)
    }

    private func makeConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(72)
            make.height.equalTo(326)
            
        }
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(spacer.space16)
            make.size.equalTo(spacer.iconSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(spacer.space48)
            make.leading.equalToSuperview().inset(spacer.space16)
            make.trailing.lessThanOrEqualToSuperview().inset(spacer.space16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space8)
            make.leading.equalToSuperview().inset(spacer.space16)
            make.trailing.lessThanOrEqualToSuperview().inset(spacer.space16)
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
        let username: String
        let name: String
        let lastName: String
        let infoMessage: String
        let image: UIImage
        let callImage: UIImage
        let gradientColors: [UIColor]
        let detailsBackgroundColor: UIColor
        let detailsButtonBackgroundColor: UIColor
        let isFavorite: Bool
    }
    
    func configure(with viewModel: ViewModel) {
        self.gradientColors = viewModel.gradientColors
        containerView.layoutIfNeeded()
        
        iconImageView.image = viewModel.image
        titleLabel.text = viewModel.name
        descriptionLabel.text = viewModel.lastName
        subDescriptionLabel.text = viewModel.infoMessage
        callIconView.configure(with: .init(image: viewModel.callImage))
        changeAppearance(isSelected: false)
    }
}
