//
//  BottomButton.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 16.03.23.
//

import UIKit
import SnapKit
import QuartzCore

public enum BottomButtonType {
    case speaker
    case video
    case mute
    case end
    case defaultType
}

public protocol BottomButtonDelegate: AnyObject {
    func bottomButtonTapped(type: BottomButtonType, isOn: Bool)
}

public final class BottomButton: UIView {
    weak var delegate: BottomButtonDelegate?
    
    private var image = UIImage()
    private var isOn: Bool = false
    
    private var type: BottomButtonType = .defaultType

    private lazy var imageIconView: UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(FontSize.size12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    public init(image: UIImage, name: String, type: BottomButtonType) {
        super.init(frame: .zero)
        self.image = image
        self.type = type
        title.text = name
        imageIconView.clipsToBounds = true
        imageIconView.layer.cornerRadius = 25
        let tintedImage = generateTintedImage(image: image, color: .white, backgroundColor: Colors.whiteColorWithAlpha020)
        imageIconView.image = tintedImage
        
        imageIconView.alpha = 1.0
        imageIconView.layer.animateAlpha(from: 0.4, to: 1.0, duration: 0.2)
        imageIconView.alpha = 1.0
        imageIconView.layer.animateAlpha(from: 0.4, to: 1.0, duration: 0.2)

        addSubview(title)
        addSubview(imageIconView)
        imageIconView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        title.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(imageIconView.snp.bottom).offset(4)
        }
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func generateTintedImage(image: UIImage?, color: UIColor, backgroundColor: UIColor? = nil) -> UIImage? {
        guard let image = image else {
            return nil
        }
        
        let imageSize = image.size

        UIGraphicsBeginImageContextWithOptions(imageSize, false, image.scale)
        if let context = UIGraphicsGetCurrentContext() {
            if let backgroundColor = backgroundColor {
                if backgroundColor == UIColor.clear {
                    context.clear(CGRect(origin: CGPoint(), size: imageSize))
                } else {
                    context.setFillColor(backgroundColor.cgColor)
                    context.fill(CGRect(origin: CGPoint(), size: imageSize))
                }
            }
            
            let imageRect = CGRect(origin: CGPoint(), size: imageSize)
            context.saveGState()
            context.translateBy(x: imageRect.midX, y: imageRect.midY)
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: -imageRect.midX, y: -imageRect.midY)
            context.clip(to: imageRect, mask: image.cgImage!)
            if color == UIColor.clear {
                context.clear(imageRect)
            } else {
                context.setFillColor(color.cgColor)
                context.fill(imageRect)
            }
            context.restoreGState()
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
    
    @objc private func viewTapped() {
        isOn.toggle()
        delegate?.bottomButtonTapped(type: type, isOn: isOn)
        
        let newImage = generateTintedImage(image: image, color: isOn ? .clear : UIColor.white, backgroundColor: isOn ? .white : Colors.whiteColorWithAlpha020)
        let cgNewImage = newImage!.cgImage!
        
        let oldImage = imageIconView.image
        imageIconView.image = newImage
        imageIconView.layer.animateScale(from: 1, to: 1.12, duration: 0.1, completion: { _ in
            self.imageIconView.layer.animateScale(from: 1.12, to: 1, duration: 0.1)
        })
        imageIconView.layer.animate(from: oldImage?.cgImage!, to: cgNewImage, keyPath: "contents", timingFunction: CAMediaTimingFunctionName.easeInEaseOut.rawValue, duration: 0.2)
        imageIconView.layer.animateSpring(from: 0.01 as NSNumber, to: 1 as NSNumber, keyPath: "sdad", duration: 0.5)
    }
}




extension CALayer {
    func animateAlpha(from: CGFloat, to: CGFloat, duration: Double, delay: Double = 0.0, timingFunction: String = CAMediaTimingFunctionName.easeInEaseOut.rawValue, mediaTimingFunction: CAMediaTimingFunction? = nil, removeOnCompletion: Bool = true, completion: ((Bool) -> ())? = nil) {
        self.animate(from: NSNumber(value: Float(from)), to: NSNumber(value: Float(to)), keyPath: "opacity", timingFunction: timingFunction, duration: duration, delay: delay, mediaTimingFunction: mediaTimingFunction, removeOnCompletion: removeOnCompletion, completion: completion)
    }
    
    func animate(from: AnyObject?, to: AnyObject, keyPath: String, timingFunction: String, duration: Double, delay: Double = 0.0, mediaTimingFunction: CAMediaTimingFunction? = nil, removeOnCompletion: Bool = true, additive: Bool = false, completion: ((Bool) -> Void)? = nil) {
        let animation = self.makeAnimation(from: from, to: to, keyPath: keyPath, timingFunction: timingFunction, duration: duration, delay: delay, mediaTimingFunction: mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: additive, completion: completion)
        self.add(animation, forKey: additive ? nil : keyPath)
    }
    
    func animateScale(from: CGFloat, to: CGFloat, duration: Double, delay: Double = 0.0, timingFunction: String = CAMediaTimingFunctionName.easeInEaseOut.rawValue, mediaTimingFunction: CAMediaTimingFunction? = nil, removeOnCompletion: Bool = true, additive: Bool = false, completion: ((Bool) -> Void)? = nil) {
        self.animate(from: NSNumber(value: Float(from)), to: NSNumber(value: Float(to)), keyPath: "transform.scale", timingFunction: timingFunction, duration: duration, delay: delay, mediaTimingFunction: mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: additive, completion: completion)
    }
    
    func animateSpring(from: AnyObject, to: AnyObject, keyPath: String, duration: Double, delay: Double = 0.0, initialVelocity: CGFloat = 0.0, damping: CGFloat = 88.0, removeOnCompletion: Bool = true, additive: Bool = false, completion: ((Bool) -> Void)? = nil) {
        let animation: CABasicAnimation
        animation = makeSpringBounceAnimation(keyPath: keyPath, initialVelocity: initialVelocity, damping: damping)
        animation.fromValue = from
        animation.toValue = to
        animation.isRemovedOnCompletion = removeOnCompletion
        animation.fillMode = .forwards
        
        let k = Float(1)
        var speed: Float = 1.0
        if k != 0 && k != 1 {
            speed = Float(1.0) / k
        }
        
        if !delay.isZero {
            animation.beginTime = self.convertTime(CACurrentMediaTime(), from: nil) + delay * 1
            animation.fillMode = .both
        }
        
        animation.speed = speed * Float(animation.duration / duration)
        animation.isAdditive = additive
        
        
        self.add(animation, forKey: keyPath)
    }
    
    func makeSpringBounceAnimation(keyPath: String?, initialVelocity: CGFloat, damping: CGFloat) -> CASpringAnimation {
        let springAnimation = CASpringAnimation(keyPath: keyPath)
        springAnimation.mass = 5.0
        springAnimation.stiffness = 900
        springAnimation.damping = damping
        springAnimation.initialVelocity = initialVelocity
        springAnimation.duration = springAnimation.settlingDuration
        springAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        return springAnimation
    }
    
    func makeAnimation(from: AnyObject?, to: AnyObject, keyPath: String, timingFunction: String, duration: Double, delay: Double = 0.0, mediaTimingFunction: CAMediaTimingFunction? = nil, removeOnCompletion: Bool = true, additive: Bool = false, completion: ((Bool) -> Void)? = nil) -> CAAnimation {
        
        let k = Float(1)
        var speed: Float = 1.0
        if k != 0 && k != 1 {
            speed = Float(1.0) / k
        }
        
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        if let mediaTimingFunction = mediaTimingFunction {
            animation.timingFunction = mediaTimingFunction
        } else {
            switch timingFunction {
            case CAMediaTimingFunctionName.linear.rawValue, CAMediaTimingFunctionName.easeIn.rawValue, CAMediaTimingFunctionName.easeOut.rawValue, CAMediaTimingFunctionName.easeInEaseOut.rawValue, CAMediaTimingFunctionName.default.rawValue:
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: timingFunction))
            default:
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            }
            
        }
        animation.isRemovedOnCompletion = removeOnCompletion
        animation.fillMode = .forwards
        animation.speed = speed
        animation.isAdditive = additive
        animation.delegate = CALayerAnimationDelegate(animation: animation, completion: completion)
        
        if !delay.isZero {
            animation.beginTime = self.convertTime(CACurrentMediaTime(), from: nil) + delay * 1
            animation.fillMode = .both
        }
        
        
        return animation
    }
}

@objc private class CALayerAnimationDelegate: NSObject, CAAnimationDelegate {
    private let keyPath: String?
    var completion: ((Bool) -> Void)?
    
    init(animation: CAAnimation, completion: ((Bool) -> Void)?) {
        if let animation = animation as? CABasicAnimation {
            self.keyPath = animation.keyPath
        } else {
            self.keyPath = nil
        }
        self.completion = completion
        
        super.init()
    }
    
    @objc func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let anim = anim as? CABasicAnimation {
            if anim.keyPath != self.keyPath {
                return
            }
        }
        if let completion = self.completion {
            completion(flag)
            self.completion = nil
        }
    }
}
