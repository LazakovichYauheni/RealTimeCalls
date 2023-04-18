import UIKit

final class RadialGradientLayer: CAGradientLayer {
    override init(layer: Any) {
        super.init(layer: layer)
    }
    init(frame: CGRect, startAngle: CGFloat, color: UIColor) {
        super.init()
        
        commonInit(color: color)
        setupAnimation(frame: frame, startAngle: startAngle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(color: UIColor) {
        commonInit(color: color)
    }
    
    private func commonInit(color: UIColor) {
        self.startPoint = .init(x: 0.5, y: 0.5)
        self.endPoint = .init(x: 1, y: 1)
        self.type = .radial
        self.colors = [
            color.withAlphaComponent(0.8).cgColor,
            color.withAlphaComponent(0.01).cgColor
        ]
    }
    
    private func setupAnimation(frame: CGRect, startAngle: CGFloat) {
        let path = UIBezierPath()
        path.addArc(
            withCenter: .zero,
            radius: 0.45,
            startAngle: startAngle,
            endAngle: 2 * .pi + startAngle,
            clockwise: true
        )
        
        path.close()
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, frame.midX, frame.midY)
        transform = CGAffineTransformScale(transform, frame.width, frame.height)
        path.apply(transform)
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 3.5
        animation.repeatCount = .greatestFiniteMagnitude
        animation.path = path.reversing().cgPath
        animation.calculationMode = .paced
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        add(animation, forKey: nil)
    }
}

