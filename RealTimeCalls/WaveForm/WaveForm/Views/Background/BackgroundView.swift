import UIKit

final class BackgroundView: UIView {    
    private lazy var firstLayer = RadialGradientLayer(
        frame: frame,
        startAngle: 2 * Double.pi,
        color: Color.current.calls.blobs.blueYellowColors[0]
    )
    
    private lazy var secondLayer = RadialGradientLayer(
        frame: frame,
        startAngle: Double.pi,
        color: Color.current.calls.blobs.blueYellowColors[1]
    )
    private lazy var backgroundLayer = BaseLayer(color: Color.current.calls.background.greenColor)
    
    private lazy var size = CGRect(x: .zero, y: .zero, width: frame.height + 50, height: frame.height + 50)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        firstLayer.frame = size
        secondLayer.frame = size
        backgroundLayer.frame = bounds
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(firstLayer)
        layer.addSublayer(secondLayer)
    }
    
    public func changeColors(blobsColors: [UIColor], backgroundColor: UIColor) {
        backgroundLayer.set(color: backgroundColor)
        firstLayer.set(color: blobsColors[0])
        secondLayer.set(color: blobsColors[1])
    }
}
