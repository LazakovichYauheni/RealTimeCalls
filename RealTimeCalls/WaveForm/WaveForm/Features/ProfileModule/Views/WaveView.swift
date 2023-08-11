//
//  WaveView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 10.08.23.
//

import UIKit

final class WaveView: UIView {
    private var waveLayer = CAShapeLayer()
    private var waveLine = UIBezierPath()
    private var timer = Timer()
    private var drawSeconds: CGFloat = 0
    private var drawElapsedTime: CGFloat = 0
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [
            Color.current.background.gradientBackgroundFirstColors[0].cgColor,
            Color.current.background.gradientBackgroundSecondColors[0].cgColor
        ]
            
        timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(waveAnimation), userInfo: nil, repeats: true)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        gradientLayer.frame = bounds
        wave()
    }
    
    @objc private func waveAnimation() {
        setNeedsDisplay()
    }
    
    private func wave() {
        waveLine.removeAllPoints()
        drawSeconds += 0.003
        drawElapsedTime = drawSeconds * CGFloat(Double.pi)
        drawWave()
    }
    
    
    private func drawWave() {
        let path = makeWavePath(width: 100)
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY))
        path.close()
        waveLayer.path = path.cgPath
        gradientLayer.mask = waveLayer
        layer.addSublayer(gradientLayer)
    }
    
    private func makeWavePath(width: CGFloat) -> UIBezierPath {
        let centerY = bounds.midY
        let amplitude: CGFloat = 5
        
        func f(_ x: CGFloat) -> CGFloat {
            return cos((x + drawElapsedTime) * 4 * .pi) * amplitude + centerY
        }
        
        let path = UIBezierPath()
        let steps = Int(bounds.width / 2)

        path.move(to: CGPoint(x: 0, y: f(0)))
        for step in 1 ... steps {
            let x = CGFloat(step) / CGFloat(steps)
            path.addLine(to: CGPoint(x: x * bounds.width, y: f(x)))
        }

        return path
    }
    
    
}
